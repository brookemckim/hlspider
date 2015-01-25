require 'spec_helper'

describe HLSpider::Spider do
  include WebMock::API

  before do
    WebMock.reset!
    @playlist  = "http://host.com/playlist.m3u8"
    @playlists = ["http://host.com/playlist.m3u8", "http://host.com/playlist2.m3u8"]
    stub_request(:get, "http://host.com/playlist.m3u8").to_return({:status => 200, :headers => {}, :body => %q{#EXTM3U
#EXT-X-TARGETDURATION:10
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-PLAYLIST-TYPE:VOD
#EXTINF:7.12,
segment00000.ts
segment00001.ts
#EXT-X-ENDLIST
    }})
    stub_request(:get, "http://host.com/playlist2.m3u8").to_return({:status => 200, :headers => {}, :body => %q{#EXTM3U
#EXTM3U
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=673742
playlist.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=204909
playlist3.m3u8
    }})

    stub_request(:get, "http://host.com/playlist3.m3u8").to_return({:status => 200, :headers => {}, :body => %q{#EXTM3U
#EXT-X-TARGETDURATION:10
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-PLAYLIST-TYPE:VOD
#EXTINF:7.12,
segment00000.ts
segment00001.ts
segment00002.ts
#EXT-X-ENDLIST
    }})

    stub_request(:get, "http://host.com/playlist4.m3u8").to_return({:status => 200, :headers => {}, :body => %q{#EXT-X-TARGETDURATION:10}})
  end

  it "can be created with a String" do
    HLSpider::Spider.new(@playlist).must_be_instance_of(HLSpider::Spider)
  end

  it "can be created with an Array" do
    HLSpider::Spider.new(@playlists).must_be_instance_of(HLSpider::Spider)
  end

  it "should download the playlist content when parsing it" do
    spider = HLSpider::Spider.new(@playlist)
    spider.playlists.count.must_equal(1)
    spider.playlists[0].must_be_instance_of(HLSpider::Playlist)
    assert_requested(:get, @playlist)
  end

  it "should download recursively when the playlist if of playlists" do
    spider = HLSpider::Spider.new(@playlists)
    spider.playlists.count.must_equal(3)
    spider.playlists[0].must_be_instance_of(HLSpider::Playlist)
    spider.playlists[1].must_be_instance_of(HLSpider::Playlist)
    spider.playlists[2].must_be_instance_of(HLSpider::Playlist)
    assert_requested(:get, "http://host.com/playlist.m3u8", :times => 2)
    assert_requested(:get, "http://host.com/playlist2.m3u8")
    assert_requested(:get, "http://host.com/playlist3.m3u8")
  end

  it "should raise error when the playlist is invalid" do
    spider = HLSpider::Spider.new("http://host.com/playlist4.m3u8")
    assert_raises(HLSpider::Spider::InvalidPlaylist) {
      spider.playlists
    }
  end

  it "should return the last segment of each playlist" do
    spider = HLSpider::Spider.new(@playlists)
    spider.last_segments.must_equal([0, 0, 0])
  end

  it "should check if the playlists are aligned" do
    spider = HLSpider::Spider.new(@playlists)
    spider.aligned?.must_equal(true)
  end
end
