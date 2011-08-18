require 'rubygems'
require 'em-synchrony'
require 'em-synchrony/em-http'
require 'logger'
require_relative 'playlist'  

module HLSpider
  class Spider
    def initialize(playlists, logfile = "")
      @playlists = playlists
      @log = Logger.new(logfile) unless logfile.empty?
    end  
  
    def crawl
      playlists = dive(@playlists)
    
      segments = []
      playlists.each { |p| segments << p.segments.first }
      
      puts Time.now
      put_and_log "--- #{segments.inspect} ---"
      segments.uniq!
    
      if segments.size > 1 && ((segments[0].to_i - segments[1].to_i).abs > 1)
        p "Segments are off - #{@time}"
        log "**********"
        log segments.inspect
        log "**********"
      elsif segments.size == 1
        p "All Good. at #{segments[0]}"
        log "^^^^^^^^^^^"
        log segments.inspect
        log "^^^^^^^^^^^"
      else  
        p "No segements found - #{@time}"
        log "~~~~~~~~~~~"
        log "No segments!"
        log "~~~~~~~~~~~"
      end  
    end
    
    private
    
    def async_download(urls = [])
      res = nil
      
      EM.synchrony do
        multi = EventMachine::Synchrony::Multi.new
        
        urls.each_with_index do |p,i|
          log p
          multi.add :"#{i}", EventMachine::HttpRequest.new(p).aget
          @time = Time.now
        end  
  
        res = multi.perform
    
        EventMachine.stop         
      end  
      
      return res   
    end  
    
    def dive(urls = [])
      playlists = []
            
      res = async_download(urls)              
      res.requests.each do |req|
        p = Playlist.new(req.response, req.req.uri.to_s)
      
        if p.valid?
          if p.variable_playlist?
            playlists = dive(p.playlists)
          else
            playlists << p
          end 
        end  
      end
      
      return playlists  
    end  
    
    def log(str)
      #eval "@log.#{type} \"#{str}\"" if @log
      @log.info str if @log
    end
    
    def put_and_log(str)
      log(str)
      puts str
    end    
  end  
end