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

    @extra_media_playlist = %q{#EXTM3U
#EXT-X-FAXS-CM:URI="iphone360.mp4.drmmeta"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aac",NAME="Portuguese",DEFAULT=YES,AUTOSELECT=YES,LANGUAGE="pt",URI="iphone.m3u8"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aac",NAME="SAP",DEFAULT=NO,AUTOSELECT=YES,LANGUAGE="en",URI="sap.m3u8"
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=673742,CODECS="mp4a.40.2,avc1.4d401e",AUDIO="aac"
web.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=401437,CODECS="mp4a.40.2,avc1.4d401e",AUDIO="aac"
iphone.m3u8
    }

    @querystring_playlist = %q{#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=500000
chunklist-b500000.m3u8?wowzasessionid=2030032484
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1000000
chunklist-b1000000.m3u8?wowzasessionid=2030032484
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1400000
chunklist-b1400000.m3u8?wowzasessionid=2030032484
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=96000
chunklist-b96000.m3u8?wowzasessionid=2030032484&wowzaaudioonly
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

  it "should accept extra media urls on playlists" do
    playlist = HLSpider::Playlist.new(@extra_media_playlist, "http://host.com/main/playlist.m3u8")
    playlist.playlists.must_equal([
    "http://host.com/main/iphone.m3u8",
    "http://host.com/main/sap.m3u8",
    "http://host.com/main/web.m3u8",
    "http://host.com/main/iphone.m3u8"
    ])
  end

  it "should accept urls with querystings on playlists" do
    playlist = HLSpider::Playlist.new(@querystring_playlist, "http://host.com/main/playlist.m3u8")
    playlist.playlists.must_equal([
    "http://host.com/main/chunklist-b500000.m3u8?wowzasessionid=2030032484",
    "http://host.com/main/chunklist-b1000000.m3u8?wowzasessionid=2030032484",
    "http://host.com/main/chunklist-b1400000.m3u8?wowzasessionid=2030032484",
    "http://host.com/main/chunklist-b96000.m3u8?wowzasessionid=2030032484&wowzaaudioonly"
    ])
  end
end
