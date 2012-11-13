# Internal: Reponse from the downloader which contains the response body 
# and the request url.
module HLSpider
  class Response
    def initialize(url, body)
      @url = url
      @body = body
    end

    attr_reader :url, :body
  end
end

