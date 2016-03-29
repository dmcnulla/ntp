require 'socket'

module Ntp
  class Server
    attr_accessor :server, :port

    def initialize(port = 123)
      @port = port
    end

    # runs the server
    def start
      reset
    end

    # stops the server
    def stop
    end

    # sets a new time for the NTP server to base future responses
    def change_time(new_time)
      @time = new_time
    end

    # sets the time to current time to base future responses
    def reset
      @time = Time.now
    end

    # only used for practing the cukes
    # def get_time
    #   @time
    # end
  end
end
