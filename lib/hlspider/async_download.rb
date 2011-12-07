# Internal: Asynchronsoly downloads urls and returns Array of responses.
require 'eventmachine'
require 'em-http-request'

module HLSpider
  module AsyncDownload
    # Internal: Asynchronosly download given URLs.
    #
    # urls  - An Array of strings or a single string of URL(s)
    #
    # Examples
    #
    #   async_download(["http://www.google.com", "http://www.yahoo.com"])
    #   # => 
    #
    #   async_download("http://www.bing.com")
    #   # => 
    #
    # Returns the Array of responses.
    # Raises error if there is a request problem. 
    def async_download(urls)
      urls = Array.new(urls)
      
      puts urls.inspect
      
      responses = nil
      EventMachine.run {
        multi = EventMachine::MultiRequest.new

        urls.each_with_index do |url, idx|
          http = EventMachine::HttpRequest.new(url, :connect_timeout => 10)
          req = http.get
          multi.add idx, req
        end

        multi.callback  do
          responses = multi.responses
          EventMachine.stop
        end
      }

      if responses[:callback].size == urls.size
        responses[:callback].collect { |k,v| v }
      else
        puts "Connection Error"
        #raise ConnectError
      end    
    end  
  end  
end  