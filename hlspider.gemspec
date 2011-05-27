# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hlspider/version"

Gem::Specification.new do |s|
  s.name        = "hlspider"
  s.version     = Hlspider::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brooke McKim"]
  s.email       = ["bmckim@telvue.com"]
  s.homepage    = ""
  s.summary     = %q{ASYNC .m3u8 downloader}
  s.description = %q{Downloads .m3u8 playlist files and confirms their segments are properly aligned.}

  s.rubyforge_project = "hlspider"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('thor', '>= 0.14.0')
  s.add_dependency('em-synchrony', '>= 0.3.0.beta.1')
  s.add_dependency('eventmachine', '>= 1.0.0.beta.3')
  s.add_dependency('em-http-request', '>= 1.0.0.beta.3')  
end
