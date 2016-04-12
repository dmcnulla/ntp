require 'simplecov'
require 'rubygems'
require 'rspec/expectations'
require 'rspec/wait'
require 'cucumber/rspec/doubles'
require 'coveralls'
require 'net/ntp'
require 'pry'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'features'
end

World(RSpec::Wait)

RSpec.configure do |config|
  config.wait_timeout = 4 # seconds
end

require 'ntp'

SERVER_PORT = 55555
