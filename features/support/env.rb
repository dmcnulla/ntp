require 'rubygems'
require 'rspec/expectations'
require 'rspec/wait'
require 'cucumber/rspec/doubles'
require 'net/ntp'
require 'pry'

World(RSpec::Wait)

RSpec.configure do |config|
  config.wait_timeout = 4 # seconds
end

require 'ntp'

SERVER_PORT = 55555
