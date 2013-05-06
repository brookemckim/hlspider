# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hlspider/version"

Gem::Specification.new do |s|
  s.name        = "hlspider"
  s.version     = HLSpider::VERSION
  s.authors     = ["brookemckim"]
  s.email       = ["brooke.mckim@gmail.com"]
  s.homepage    = "http://www.github.com/brookemckim/hlspider"
  s.summary     = %q{Download and parse .m3u8 playlists.}
  s.description = %q{Downloads .m3u8 playlists and reports back on whether or not the playlists are aligned in time.}

  s.rubyforge_project = "hlspider"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here
  s.add_development_dependency 'minitest', '~> 2.7.0'
  s.add_development_dependency 'webmock'
end
