require 'rubygems'
require 'rspec/expectations'
require 'rspec/wait'
require 'cucumber/rspec/doubles'
require 'net/ntp'
require 'pry'
require 'rack/test'
require 'capybara'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'sinatra'

World(RSpec::Wait)

RSpec.configure do |config|
  config.wait_timeout = 4 # seconds
end

require 'ntp'
require 'adminhost'

SERVER_PORT = 55555

Capybara.default_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  options = {
    js_errors: false,
    timeout: 120,
    debug: false,
    phantomjs_options: ['--load-images=no', '--disk-cache=false'],
    inspector: true
  }

  Capybara::Poltergeist::Driver.new(app, options)
end

module AppHelper
  def app
    Adminhost
  end
end

World(Rack::Test::Methods, AppHelper)
