require 'spec_helper'

describe HLSpider do
  before do
    @spider = HLSpider.new("http://host.com/playlist.m3u8")
  end  
  
  it "should instansiate a Spider class" do
    @spider.must_be_kind_of(HLSpider::Spider)
  end
end
  