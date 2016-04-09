# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
module NTP
   module Server; end
end
require 'ntp/server/version'

Gem::Specification.new do |s|
   s.name         = "ntp-mock-server"
   s.version      = ::NTP::Server::VERSION
   s.platform     = Gem::Platform::RUBY
   s.authors      = [ 'Dave McNulla', 'Малъ Скрылёвъ (Malo Skrylevo)' ]
   s.email        = [ 'mcnulla@gmail.com', 'majioa@yandex.ru' ]
   s.homepage     = 'https://github.com/dmcnulla/ntp'
   s.summary      = 'NTP Mock Server'
   s.description  = 'NTP Mock Server allows to rebase server time for various test suite purposes.'
   s.license      = 'MIT'

   s.rubyforge_project = "ntp-mock-server"
   s.files             = `git ls-files`.split("\n")
   s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
   s.executables       = `git ls-files -- bin/*`.split( "\n" ).map{ |f| File.basename(f) }
   s.bindir            = "bin"
   s.require_paths     = [ "lib" ]
   s.extra_rdoc_files  = [ 'README.md', 'LICENSE.txt' ] | `find html/ 2>/dev/null`.split( "\n" )

   s.add_development_dependency 'bundler', '~> 1.5'
   s.add_development_dependency 'cucumber', '~> 2.3.3'
   s.add_development_dependency 'rake', '~> 11.1'
   s.add_development_dependency 'rspec-expectations', '~> 3.4.0'
   s.add_development_dependency 'rspec-wait', '~> 0.0.8'
   s.add_development_dependency 'coveralls', '~> 0.8.13'
   s.add_development_dependency 'simplecov', '~> 0.11.2'

   s.add_dependency 'eventmachine', '~> 1.2.0'
   s.add_dependency 'ruby-fifo', '~> 0.1.0'
   s.add_dependency 'mkfifo', '~> 0.1.1'
   s.add_dependency 'net-ntp', '~> 2.1.3'

   s.required_rubygems_version = '>= 1.6.0'
   s.required_ruby_version = '>= 1.9.3' ; end
