$:.push File.dirname(__FILE__)

require 'hlspider/version'
require 'hlspider/downloader'
require 'hlspider/playlist_line'
require 'hlspider/playlist'
require 'hlspider/spider'

module HLSpider
  def self.new(*args)
    HLSpider::Spider.new(*args)
  end  
end
