require 'rubygems'
require 'rspec/expectations'
require 'cucumber/rspec/doubles'
require 'net/ntp'

SERVER_PORT = 1234

require File.expand_path(File.join(File.dirname(__FILE__),
                                   '..', '..', 'lib', 'ntpserver.rb'))
