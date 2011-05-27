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
      EM.synchrony do
        multi = EventMachine::Synchrony::Multi.new
        @playlists.each_with_index do |p,i|
          log p
          puts "Downloading: #{p}"
          multi.add :"#{i}", EventMachine::HttpRequest.new(p).aget
          @time = Time.now
        end  
    
        res = multi.perform
      
        responses = []
        res.requests.each do |req|
          responses << {:title => req.req.uri.to_s, :body => req.response}
        end
        segments = Playlist.first_segment_numbers(responses)
        log "--- #{segments.inspect} ---"
        segments.uniq!
      
        if segments.size > 1 && ((segments[0].to_i - segments[1].to_i).abs > 1)
          p "Segments are off #{@time}"
          log "**********", "error"
          log segments.inspect, "error"
          log "**********", "error"
        else
          p "All Good. at #{segments[0]}"
          log "^^^^^^^^^^^"
          log segments.inspect
          log "^^^^^^^^^^^"
          end  
        end  

        EventMachine.stop
      end
    end
    
    private
    
    def log(str, type = 'info')
      eval "@log.#{type} \"#{str}\"" if @log
    end  
  end  
end