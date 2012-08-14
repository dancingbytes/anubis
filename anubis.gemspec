# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "anubis/version"

Gem::Specification.new do |s|

  s.name        = 'anubis'
  s.version     = ::Anubis::VERSION
  s.platform    = ::Gem::Platform::RUBY
  s.authors     = ['redfield', 'Tyralion']
  s.email       = ['info@dancingbytes.ru']
  s.homepage    = 'https://github.com/dancingbytes/anubis'
  s.summary     = 'Simple search on Sphinx for ruby/rails'
  s.description = 'Sphinx (only SphinxQL support) wrapper for Ruby/Rails'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.md']
  s.require_paths = ['lib']

  s.licenses    = ['BSD']

  s.add_dependency 'bundler', ['>= 1.0.0']
  s.add_dependency 'em-synchrony', ['>= 1.0.2']
  s.add_dependency 'mysql2',  ['>= 0.3.11']

end