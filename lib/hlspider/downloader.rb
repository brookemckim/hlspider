# Internal: Asynchronsoly downloads urls and returns Array of responses.
require 'eventmachine'
require 'em-http-request'

module HLSpider
  module Downloader
    class ConnectionError < StandardError; end;
    
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
    # Raises HLSpider::Downloader::ConnectionError if there was a problem
    # downloading all urls. 
    def download(urls)
      urls = Array(urls)
            
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
        raise ConnectionError, "Not able to download all playlsts."
      end    
    end  
  end  
end  