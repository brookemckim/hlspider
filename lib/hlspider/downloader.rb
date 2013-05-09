require 'net/http'
require 'hlspider/response'

# Internal: Asynchronsoly downloads urls and returns Array of responses.
module HLSpider
  module Downloader
    # Internal: Download given URLs.
    #
    # urls - An Array of strings or a single string of URL(s)
    #
    # Examples
    #
    #   download(["http://www.google.com", "http://www.yahoo.com"])
    #   # => []
    #
    #   download("http://www.bing.com")
    #   # => []
    #
    # Returns the Array of responses.
    # Raises HLSpider::Downloader::DownloadError if there was a problem
    # downloading all urls.
    def download(urls)
      urls = Array(urls)

      responses = []
      threads = []

      urls.each do |url|
        threads << Thread.new {
          uri = URI.parse(url)
          body = Net::HTTP.get_response(uri).body

          responses << Response.new(url, body)
        }

        threads.each { |t| t.join }
      end

      responses
    end
  end
end
