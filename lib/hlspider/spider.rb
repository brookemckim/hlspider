require 'em-synchrony'
require 'em-synchrony/em-http'
require 'logger'

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
        p "No segemnts found - #{@time}"
        log "~~~~~~~~~~~"
        log "No segments!"
        log "~~~~~~~~~~~"
      end  
    end
    
    private
    
    def async_download(urls = [])
      EM.synchrony do
      
        multi = EventMachine::Synchrony::Multi.new
        urls.each_with_index do |p,i|
          log p
          puts "Downloading: #{p}"
          multi.add :"#{i}", EventMachine::HttpRequest.new(p).aget
          @time = Time.now
        end  
  
        res = multi.perform
      end  
      
      EventMachine.stop
      
      return res
    end  
    
    def dive(playlists = [])
      playlists.each do |p|
        res = async_download(playlist.playlists)
        
        res.requests.each do |req|
          playlist = Playlist.new(req.response, req.req.uri.to_s)
          
          if playlist.valid?
            if playlist.variable_playlist?
              return dive(playlist.playlists)
            else
              return playlist
            end 
          else
            nil
          end    
        
        end  
      end
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