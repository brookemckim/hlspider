module HLSpider
  class Playlist
    attr_accessor :file, :source
    attr_reader   :playlists, :segments
  
    def initialize(file, source = '')
      @file   = file
      @source = source
       
      @valid = false
      @variable_playlist = false
      @segment_playlist  = false
    
      @playlists = []
      @segments  = []
    
      parse
    end

    def variable_playlist?
      @variable_playlist
    end  

    def segment_playlist?
      @segment_playlist
    end  

    def valid?
      @valid
    end  

    def to_s
      @file
    end  
  
  private
    def parse
      @valid = true if /#EXTM3U/.match(@file)
    
      if has_playlist?(@file) && !has_segment?(@file)
        @variable_playlist = true 
        @file.each_line do |line|
          @playlists << line.strip if has_playlist?(line)
        end  
      elsif has_segment?(@file) && !has_playlist?(@file)
        @segment_playlist  = true
        @file.each_line do |line|
          @segments << line.strip if has_segment?(line)
        end 
      else
        @valid = false   
      end
    end
  
    def has_segment?(str)
      true if /.ts/.match(str)
    end
  
    def has_playlist?(str)
      true if /.m3u8/.match(str)
    end               
  end
end
