require 'rubygems'
require 'thor'

module HLSpider
  class HLSpider < ::Thor
    
    desc "crawl", "Crawl the specified playlists and make sure their segments align"
    method_option :playlists, :type => :array,   :default => [], :required => true
    method_option :sleep,     :type => :numeric, :default => 5
    method_option :log,       :type => :string,  :default => ""
    def crawl
      while true
        Spider.new(options[:playlists], options[:log]).crawl
        sleep options[:sleep]
      end  
    end  
  end  
end  

path = File.expand_path(File.dirname(__FILE__))
['spider', 'playlist'].each do |file|
  require File.join(path, 'hlspider', file)
end
