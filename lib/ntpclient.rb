require 'socket'
require 'timeout'
require_relative 'constants.rb'
require_relative 'ntpresponse.rb'

module Net
  # Client for retrieving NTP time.
  class NtpClient
    attr_accessor :time_response

    ###
    # Sends an NTP datagram to the specified NTP server and returns
    # a hash based upon RFC1305 and RFC2030.
    def initialize(host="pool.ntp.org", port="ntp", timeout=TIMEOUT)
      @host = host
      @port = port
      @timeout = timeout
      update
    end

    def update(timeout = nil)
      timeout ||= @timeout
      @client = UDPSocket.new
      @client.connect(@host, @port)

      @client_localtime      = Time.now.to_f
      @client_adj_localtime  = @client_localtime + NTP_ADJ
      @client_frac_localtime = frac2bin(@client_adj_localtime)

      ntp_msg = (['00011011']+Array.new(12, 0)+[@client_localtime, @client_frac_localtime.to_s]).pack("B8 C3 N10 B32")

      # read = @client.send(ntp_msg, 0, @host, @port)
      @client.flush
      read, write, error = IO.select [@client], nil, nil, timeout
      if read.nil?
        # For backwards compatibility we throw a Timeout error, even
        # though the timeout is being controlled by select()
        raise Timeout::Error
      else
        @client_time_receive = Time.now.to_f
        data, address = @client.recvfrom(960)
        @time_response = NtpResponse.new(data, @client_time_receive)
      end
      @time_response.time
    end

    def frac2bin(frac) #:nodoc:
      bin  = ''

      while bin.length < 32
        bin += ( frac * 2 ).to_i.to_s
        frac = ( frac * 2 ) - ( frac * 2 ).to_i
      end

      bin
    end
  end
end
