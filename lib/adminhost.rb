require 'sinatra'
require 'ntp'

class AdminHost < Sinatra::Base
  set :ntp, NTP::Server::Control.new.start

  get '/status' do
    [200, {}, AdminHost.ntp]
  end

  post '/time/:time' do
    [204, {}, AdminHost.ntp.time(params[:time])]
  end

  post '/time/reset' do
    [204, {}, AdminHost.ntp.reset]
  end
end
