#require 'socket'
require 'eventmachine'

module Ntp
  autoload :Handler, 'ntpserver/handler'

  class Server
    attr_accessor :host, :port

    def initialize(port = 123)
      self.host = 'localhost'
      self.port = port
    end

    # runs the server
    def start
      EventMachine::run do
        EventMachine::open_datagram_socket host, port, Handler
        puts "Started NTP Mock Server on #{host}:#{port}..."
      end
    end

    # stops the server
    def stop
      EventMachine::stop_event_loop
    end

    # sets a new time for the NTP server to base future responses
    def change_time(new_time)
      @time = new_time
    end

    # sets the time to current time to base future responses
    def reset
      @time = Time.now.utc
    end

    def status
      EventMachine::status
    end

    # only used for practing the cukes
    # def get_time
    #   @time
    # end
  end
end
