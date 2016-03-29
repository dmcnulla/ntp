require 'socket'
require_relative 'constants.rb'
# require_relative 'ntpresponse.rb'

module Ntp

  class Server
    attr_accessor :server, :port

    def initialize(port = 123)
      @port = port
    end

    # runs the server
    def start

    end

    # stops the server
    def stop

    end

    # sets a new time for the NTP server to base future responses
    def change_time(new_time)

    end

    # sets the time to current time to base future responses
    def reset

    end
  end
end
