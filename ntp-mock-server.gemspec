# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
   s.name         = "ntp-mock-server"
   s.version      = 0.1
   s.platform     = Gem::Platform::RUBY
   s.authors      = [ 'Малъ Скрылёвъ (Malo Skrylevo)' ]
   s.email        = [ '3aHyga@gmail.com' ]
   s.homepage     = 'https://github.com/dmcnulla/ntp'
   s.summary      = 'NTP Mock Server'
   s.description  = 'NTP Mock Server'
   s.license      = 'MIT'

   s.rubyforge_project = "ntp-mock-server"
   s.files             = `git ls-files`.split("\n")
   s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
   s.executables       = `git ls-files -- bin/*`.split( "\n" ).map{ |f| File.basename(f) }
   s.require_paths     = [ "lib" ]
   s.extra_rdoc_files  = [ 'README.md' ] | `find html/ 2>/dev/null`.split( "\n" )

   s.add_development_dependency 'rake', '~> 0'
   s.add_development_dependency 'bundler', '~> 1.5'

   s.required_rubygems_version = '>= 1.6.0'
   s.required_ruby_version = '>= 1.9.3' ; end
