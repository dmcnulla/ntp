require 'socket'
require_relative 'constants.rb'
# require_relative 'ntpresponse.rb'

module Net

  class NtpServer
    attr_accessor :server, :port

    def initialize(port = 123)
      @port = port
      # @server = UDPServer.new(@port)
      start
    end

    def start
      BasicSocket.do_not_reverse_lookup = true
      # Create socket and bind to address

      @server = UDPSocket.new
      @server.bind('0.0.0.0', @port) 
      while true
        puts "ready..."
        packet, addr = @server.recvfrom(1024)
        data = packet
        puts packet
        @server.send(data, 0, '10.0.0.16', "#{@port}")
      end
      @server.close
    end
  end
end
