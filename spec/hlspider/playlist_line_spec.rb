require 'spec_helper'

describe HLSpider::PlaylistLine do
  before do
    class PlaylistLine; extend HLSpider::PlaylistLine; end
    
    @segment_line  = "http://host.tld/video1/video_123123023030.ts?session=12391239"
    @playlist_line = "http://host.told/video1/playlist_123213.m3u8"
    @duration_line = "EXT-X-TARGETDURATION:55"
  end  
  
  describe "#has_segment?" do
    it "returns true on String with video segment" do
      PlaylistLine.has_segment?(@segment_line).must_equal(true)
    end  
    
    it "returns false on String without video segment" do
      PlaylistLine.has_segment?(@playlist_line).must_equal(false)
    end  
  end
  
  describe "#has_playlist?" do
    it "returns true on String with playlist" do
      PlaylistLine.has_playlist?(@playlist_line).must_equal(true)
    end  
    
    it "returns false on String without playlist" do
      PlaylistLine.has_playlist?(@segment_line).must_equal(false)
    end  
  end    
  
  describe "#duration_line?" do
    it "returns true on String with playlist duration" do
      PlaylistLine.duration_line?(@duration_line).must_equal(true)
    end  
    
    it "returns false on String without playlist duration" do
      PlaylistLine.duration_line?(@playlist_line).must_equal(false)
    end  
  end 
  
  describe "#parse_duration" do
    it "returns Integer duration on String with duration" do
      PlaylistLine.parse_duration(@duration_line).must_equal(55)
    end 
    
    it "returns nil on String without duration" do
      PlaylistLine.parse_duration(@segment_line).must_equal(nil)
    end   
  end 
  
  describe "#filename" do
    it "returns String with filename on String with filename" do
      PlaylistLine.filename(@segment_line).must_equal("video_123123023030.ts")
    end  
  end
  
  describe "#absolute_url?" do
    it "returns true for full url" do
      PlaylistLine.absolute_url?("http://www.google.com/gmail/").must_equal(true)
    end  
    
    it "returns false for relative path" do
      PlaylistLine.absolute_url?("holla/dolla.m3u8").must_equal(false)
    end  
  end 
  
  describe "#media_sequence_line?" do
    it "returns false when line is not a media sequence line" do
      PlaylistLine.media_sequence_line?("!!!!!!!hello").must_equal(false)
    end
    
    it "returns true when line is a media sequence line" do
      PlaylistLine.media_sequence_line?("#EXT-X-MEDIA-SEQUENCE:1739").must_equal(true)
    end    
  end
  
  describe "#parse_sequence" do
    it "returns sequence number when the line has one" do
      PlaylistLine.parse_sequence("#EXT-X-MEDIA-SEQUENCE:1739").must_equal(1739)
    end  
    
    it "returns nil when line does not a sequence number" do
      PlaylistLine.parse_sequence("~_~").must_equal(nil)
    end  
  end        
end
  