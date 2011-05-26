module HLSpider
  class Playlist
    attr_accessor :file
    attr_reader   :playlists, :segments
  
    def self.first_segment_numbers(files = [])
      playlists = []
      files.each do |f|
        playlist = Playlist.new(f[:body])
        playlists << {:title => f[:title], :playlist => playlist} if playlist.valid?
      end  
    
      segments = []
      playlists.each do |p|
        segment = /(\d*.ts)/.match(p[:playlist].segments.first)[0].gsub(".ts", "")
        segments << segment
      end
    
      return segments         
    end  
  
    def initialize(file)
      @file = file
  
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
    include ::Line
  
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
