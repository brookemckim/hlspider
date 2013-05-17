# Internal: A set of methods for examining individual lines of m3u8 playlists.
module HLSpider
  module PlaylistLine
    # Internal: Checks if String str contains a .ts file extension
    #
    # str - String to be checked
    #
    # Examples
    #
    #   has_segment?("video_01.ts")
    #   #=> true
    #
    #   has_segment?("arandomstring")
    #   #=> false
    #
    # Returns Boolean.
    def has_segment?(str)
      !!( str[/.*.(ts|aac)(\z|\?|$)/] )
    end

    # Internal: Checks if String str contains links to .m3u8 file extensions.
    #
    # str - String to be checked
    #
    # Examples
    #
    #   has_playlist?("playlist.m3u8")
    #   #=> true
    #
    #   has_playlist?("arandomstring")
    #   #=> false
    #
    # Returns Boolean.
    def has_playlist?(str)
      !!( str[/.m3u8/] )
    end  
  
    # Internal: Checks if String str contains 'EXT-X-TARGETDURATION'.
    #
    # str - String to be checked
    #
    # Examples
    #
    #   duration_line?("EXT-X-TARGETDURATION:10")
    #   #=> true
    #
    #   duration_line?("arandomstring")
    #   #=> false
    #
    # Returns Boolean.
    def duration_line?(str)
      !!( str[/EXT-X-TARGETDURATION/] )
    end 
  
    # Internal: Parses Integer target duration out of String str
    #
    # str - String to be parsed
    #
    # Examples
    #
    #   parse_duration("EXT-X-TARGETDURATION:10")
    #   #=> 10
    #
    #   parse_duration("arandomstring")
    #   #=> nil
    #
    # Returns Integer or nil.
    def parse_duration(str)
      if dur = /EXT-X-TARGETDURATION:(\d*)\z/.match(str)
        dur[1].to_i
      else  
        nil
      end  
    end
    
    # Internal: Parses String video segment filename out of String str.
    #
    # str - String to be parsed
    #    
    # Examples
    #
    #   filename("/media/video_01.ts?query_string=22")
    #   #=> 'video_01.ts'
    #
    #   filename("arandomsring")
    #   #=> nil
    #
    # Returns String or nil.
    def filename(str)
     str.slice(/\w{1,}(.ts)/)
    end

    # Internal: Parses string and returns whether or not it is an absolute url.
    #
    # str - String to be parsed
    #    
    # Examples
    #
    #   absolute_url?("directory/file.m3u8")
    #   #=> false
    #
    #   absolute_url?("http://www.site.tld/file.m3u8")
    #   #=> true
    #
    # Returns Boolean.    
    def absolute_url?(str)
      !!( str[/\Ahtt(ps|p)\:\/\//] )
    end 
    
    # Internal: Parses string and returns whether or not it is a media sequence line.
    #
    # str - String to be parsed
    #    
    # Examples
    #
    #   media_sequence_line?("#EXT-X-MEDIA-SEQUENCE:1739")
    #   #=> true
    #
    #   media_sequence_line?("holla")
    #   #=> false
    #
    # Returns Boolean.
    def media_sequence_line?(str)
      !!( str[/EXT-X-MEDIA-SEQUENCE/] )
    end
    
    # Internal: Parses string and returns media sequence number.
    #
    # line - Line to be parsed
    #    
    # Examples
    #
    #   parse_sequence("#EXT-X-MEDIA-SEQUENCE:1739")
    #   #=> 1739
    #
    # Returns Integer or nil.
    def parse_sequence(line)  
      if sequence = /#EXT-X-MEDIA-SEQUENCE:\s*(\d*)/.match(line)
        sequence[1].to_i
      else
        nil
      end    
    end   
  end
end
