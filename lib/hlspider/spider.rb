# Public: Asynchronsoly downloads .m3u8 playlist files from specified URLs.
# 
#
# Examples
#
#   Spider.new(["http://host.tld/video1/playlist_1.m3u8", "http://host.tld/video1/playlist_2.m3u8"])
#   # => #<HLSpider::Spider:0x10cab12d0>
#
#   Spider.new("http://host.tld/video1/parent_playlist.m3u8")
#   # => #<HLSpider::Spider:0x10cab12d0>

require 'rubygems'
require 'eventmachine'
require 'em-http-request'

module HLSpider
  class Spider 
    class InvalidPlaylist < StandardError; end;
    
    # Public: Gets Array of urls.
    attr_reader :urls
    
    # Public: Gets Array of valid playlists.
    attr_reader :playlists
        
    # Public: Initialize a Playlist Spider.
    #
    # urls   - An Array containing multiple String urls to playlist files.
    #          Also accepts single String url that points to parent playlist.
    def initialize(urls)
      @urls = Array(urls)
    end  

    # Public: Starts the download of Array urls
    #
    #
    # Examples
    #
    #   crawl
    #   # => [#<HLSpider::Playlist:0x10ca9bef8>, #<HLSpider::Playlist:0x10ca9bef9>]
    #
    # Returns Array of Playlists
    def crawl!
      @playlists = dive(@urls)  
    end  
    
    # Public: Checks if playlists' segments are aligned.
    #
    #
    # Examples
    #
    #   aligned?
    #   # => true
    #
    # Returns Boolean.
    def aligned?
      last_segments.uniq.size == 1
    end  
    
    # Public: playlist getter. 
    #
    #
    # Examples
    #
    #   playlists
    #   # => [#<HLSpider::Playlist:0x10ca9bef8>, #<HLSpider::Playlist:0x10ca9bef9>]
    #
    # Returns Array of Playlists
    def playlists
      @playlists ||= crawl!
    end  
    
    # Public: Get Array of last segments across playlists. 
    #
    #
    # Examples
    #
    #   last_segments
    #   # => ['video_05.ts', 'video_05.ts', 'video_05.ts']
    #
    # Returns Array of Strings
    def last_segments
      playlists.collect { |p| p.media_sequence }
    end  
    
    private
    
    include Downloader
    
    # Internal: Download playlists from Array urls.
    #
    #
    # Examples
    #
    #   dive(["http://host.tld/video1/playlist_1.m3u8", "http://host.tld/video1/playlist_2.m3u8"])
    #   # => [#<HLSpider::Playlist:0x10ca9bef8>, #<HLSpider::Playlist:0x10ca9bef9>]
    #
    # Returns Array of Playlists.
    # Raises HLSpider::Spider::InvalidPlaylist if an invalid playlist is downloaded.
    def dive(urls = [])
      playlists = []
            
      responses = download(urls)              
      responses.each do |resp|
        p = Playlist.new(resp.response, resp.req.uri.to_s)
              
        if p.valid?
          if p.variable_playlist?
            playlists << dive(p.playlists)
          else
            playlists << p
          end 
        else
          raise InvalidPlaylist, "#{p.source} was an invalid playlist."
        end  
      end
      
      playlists.flatten  
    end     
  end  
end