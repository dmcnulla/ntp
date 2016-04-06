require 'rubygems'
require 'rspec/expectations'
require 'cucumber/rspec/doubles'
require 'net/ntp'
require 'pry'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'features'
end

require 'ntp'

SERVER_PORT = 55555
