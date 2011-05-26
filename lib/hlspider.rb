path = File.expand_path(File.dirname(__FILE__))
['line', 'spider', 'playlist'].each do |file|
  require File.join(path, 'hlspider', file)
end

playlists = ["http://hls.telvue.com/hls/lomalinda/1-1/playlist.m3u8", "http://hls.telvue.com/hls/lomalinda/1-2/playlist.m3u8", "http://hls.telvue.com/hls/lomalinda/1-3/playlist.m3u8"]

while true
  Spider.new(playlists).crawl
  sleep 5
end
module HLSpider
  class HLSpider < Thor
    
    desc "crawl", "Crawl the specified playlists and make sure their segments align"
    method_options :playlists, :type => :array, :default => [], :required => true
    method_options :sleep,     :type => :integer, :default => 5
    def crawl
      while true
        Spider.new(playlists).crawl
        sleep options[:sleep]
      end  
    end  
  end  
end  