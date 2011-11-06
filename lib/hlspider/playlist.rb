# Internal: Parses out and exposes the parts of M3U8 playlist files.
# 
# M3U8 References:
# http://developer.apple.com/library/ios/#documentation/networkinginternet/conceptual/streamingmediaguide/HTTPStreamingArchitecture/HTTPStreamingArchitecture.html
# 
# Examples
#
#   p = Playlist.new(File.read("/path/to/playlist.m3u8"), "http://url.tld/where/playlist/was/downloaded/from")
#   # => 
#   <HLSpider::Playlist:0x10c801a80 
#    @variable_playlist=false, 
#    @segments=["media_88868.ts", "media_88869.ts"], 
#    @valid=true, 
#    @file="#EXTM3U\n#EXT-X-ALLOW-CACHE:NO\n#EXT-X-TARGETDURATION:10\n#EXT-X-MEDIA-SEQUENCE:88868\n#EXTINF:10,
#           \nmedia_88868.ts\n#EXTINF:10,\nmedia_88869.ts", 
#    @target_duration="10", 
#    @playlists=[], 
#    @source="http://url.tld/where/playlist/was/downloaded/from", 
#    @segment_playlist=true
#   >

module HLSpider
  class Playlist
    # Public: Gets/Sets the raw M3U8 Playlist File.
    attr_accessor :file
    
    # Public: Gets/Sets Optional source of playlist file. Used only for reference.
    attr_accessor :source
    
    # Public: Gets sub-playlists if the playlist has child playlists (Variable Rate Playlist).
    attr_reader :playlists
    
    # Public: Gets segments contained in the playlist.
    attr_reader :segments 
    
    # Public: Gets the target duration if available. 
    attr_reader :target_duration 
    
    # Internal: Initialize a Playlist.
    #
    # file   - A String containing an .m3u8 playlist file.
    # source - A String source of where the playlist was downloaded from. (optional)
    def initialize(file, source = nil)
      @file   = file
      @source = source       
      @valid  = false
      
      @variable_playlist = false
      @segment_playlist  = false
    
      @playlists = []
      @segments  = []
    
      parse(@file)
    end  
      
    # Internal: Set the m3u8 file.
    #
    # file  - The String of the m3u8 file.
    #
    # Examples
    #
    #   file( File.read('/path/to/playlist.m3u8') )
    #   # => '#EXTM3U\n#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=713245\n
    #         http://hls.telvue.com/brightstar/2-1/playlist.m3u8?wowzasessionid=268983957'
    #
    # Returns the file String.
    def file=(file)
      @file = file
      parse(@file)
    end

    # Public: Check whether the playlist is a variable playlist or not.
    #
    #
    # Examples
    #
    #   variable_playlist?
    #   # => true
    #
    # Returns Boolean variable_playlist.
    def variable_playlist?
      @variable_playlist
    end  

    # Public: Check whether the playlist is a segment playlist or not.
    #
    #
    # Examples
    #
    #   segment_playlist?
    #   # => false
    #
    # Returns Boolean segment_playlist.
    def segment_playlist?
      @segment_playlist
    end  
    
    # Public: Check whether the playlist is valid (either a segment or variable playlist).
    #
    #
    # Examples
    #
    #   valid?
    #   # => true
    #
    # Returns Boolean valid.
    def valid?
      @valid
    end  

    # Public: Prints contents of @file.
    #
    #
    # Examples
    #
    #   to_s
    #   #=> '#EXTM3U\n#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=713245\n
    #       http://hls.telvue.com/brightstar/2-1/playlist.m3u8?wowzasessionid=268983957'
    #
    # Returns String file.
    def to_s
      @file
    end  
    alias_method :to_s, :inspect
  
  private
    include PlaylistLine
    
    # Internal: Parses @file and sets @variable_playlist, @segment_playlist, and @valid.
    #
    #
    # Examples
    #
    #   parse(playlist_file)
    #
    # Returns nothing.
    def parse(file)
      @valid = true if /#EXTM3U/.match(@file)
      
      if has_playlist?(@file) && !has_segment?(@file)
        @variable_playlist = true 
        
        @file.each_line do |line|
          @playlists << line.strip if has_playlist?(line)
        end  
      elsif has_segment?(@file) && !has_playlist?(@file)
        @segment_playlist  = true
       
        @file.each_line do |line|         
          if has_segment?(line)
            @segments << filename(line.strip)
          elsif duration_line?(line)
            @target_duration = parse_duration(line.strip)
          end              
        end         
      else
        @valid = false   
      end
    end               
  end
end
