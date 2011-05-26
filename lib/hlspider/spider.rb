require 'em-synchrony'
require 'em-synchrony/em-http'
require 'logger'

module HLSpider
  class Spider
    @@log = Logger.new('/tmp/hlspider.log')
  
    def initialize(playlists)
      @playlists = playlists
    end  
  
    def crawl
      EM.synchrony do
        multi = EventMachine::Synchrony::Multi.new
        @playlists.each_with_index do |p,i|
          multi.add :"#{i}", EventMachine::HttpRequest.new(p).aget
          @time = Time.now
        end  
    
        res = multi.perform
      
        responses = []
        res.requests.each do |req|
          responses << {:title => req.req.uri.to_s, :body => req.response}
        end
        segments = Playlist.first_segment_numbers(responses).uniq
      
        if segments.size > 1 && ((segments[0].to_i - segments[1].to_i).abs > 1)
          p "Segments are off #{@time}"
          @@log.error "**********"
          @@log.error segments.inspect
          @@log.error "**********"        
        else
          p "All Good. at #{segments[0]}"
          @@log.debug "^^^^^^^^^^^"
          @@log.debug segments.inspect
          @@log.debug "^^^^^^^^^^^"
        end  

        EventMachine.stop
      end
    end
  end  
end