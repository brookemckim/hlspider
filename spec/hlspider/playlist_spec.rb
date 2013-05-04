require 'spec_helper'

describe HLSpider::Playlist do
  before do
    @segments_playlist = %q{#EXTM3U
#EXT-X-TARGETDURATION:10
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-PLAYLIST-TYPE:VOD
#EXTINF:7.12,
segment00000.ts
segment00001.ts
#EXT-X-ENDLIST
    }

    @variable_playlist = %q{#EXTM3U
#EXTM3U
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=673742
rel/playlist.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=204909
http://anotherhost.com/playlist3.m3u8
    }
  end

  it "should identify if it is a segments playlist" do
    playlist = HLSpider::Playlist.new(@segments_playlist)
    playlist.segment_playlist?.must_equal(true)
    playlist.variable_playlist?.must_equal(false)
  end

  it "should identify if it is a variable playlist" do
    playlist = HLSpider::Playlist.new(@variable_playlist)
    playlist.variable_playlist?.must_equal(true)
    playlist.segment_playlist?.must_equal(false)
  end

  it "should resolve relative playlists" do
    playlist = HLSpider::Playlist.new(@variable_playlist, "http://host.com/main/playlist.m3u8")
    playlist.playlists[0].must_equal("http://host.com/main/rel/playlist.m3u8")
  end

  it "should accept absolute playlists" do
    playlist = HLSpider::Playlist.new(@variable_playlist, "http://host.com/main/playlist.m3u8")
    playlist.playlists[1].must_equal("http://anotherhost.com/playlist3.m3u8")
  end

  it "should same value to to_s and inspect" do
    playlist = HLSpider::Playlist.new(@segments_playlist)
    playlist.to_s.must_equal(playlist.inspect)
  end

end
