require 'sinatra'
require 'ntp'

class Adminhost < Sinatra::Base
  set :ntp_server, NTP::Server::Control.new.start
  STATUS = %w(Good Bad).freeze

  get '/healthcheck' do
    begin
      [200, {}, STATUS[0]]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      [400, {}, 'Bad Healthcheck']
    end
  end

  get '/status' do
    begin
      [200, {}, Adminhost.ntp_server.status]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      [400, {}, 'Bad Status']
    end
  end

  get '/time' do
    begin
      [200, {}, Adminho.ntp_server.get_time]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      [400, {}, 'Bad Time Retrieval']
    end
  end

  puts '/date/:date/time/:time' do
    begin
      date = params[:date].split('-')
      time = params[:time].split(':')
      new_time = Time.new(date[0], date[1], date[2], time[0], time[1], time[2])
      [204, {}, Adminho.ntp_server.time(new_time)]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      [400, {}, 'Bad Time Set']
    end
  end

  puts '/date/reset' do
    begin
      [204, {}, Adminho.ntp.reset]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      [400, {}, 'Bad Time Reset']
    end
  end
end
