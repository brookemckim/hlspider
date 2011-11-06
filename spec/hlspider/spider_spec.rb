require 'spec_helper'

describe HLSpider::Spider do
  before do
    @playlist  = "http://host.com/playlist.m3u8"
    @playlists = ["http://host.com/playlist.m3u8", "http://host.com/playlist2.m3u8"]
  end
  
  it "can be created with a String" do
    HLSpider::Spider.new(@playlist).must_be_instance_of(HLSpider::Spider)
  end    
  
  it "can be created with an Array" do
    HLSpider::Spider.new(@playlists).must_be_instance_of(HLSpider::Spider)
  end  
end  