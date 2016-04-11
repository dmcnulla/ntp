module NTP::Server::Handler
   def make_response request, receive_time
      time = ::Time.now + self.handler.gap
      response = NTP::Response.new
      response.leap_indicator = 'no warning'
      response.version_number = request.version_number
      response.mode = 'reserved for private use'
      response.stratum = 'non-synchronized'
      response.poll_interval = 6
      response.precision = 0
      response.root_delay = request.timestamp.time - receive_time
      response.root_dispersion = NTP::Time.new(0)
      response.reference_clock_identifier = '127.0.0.1'
      response.reference_timestamp = time
      response.originate_timestamp = self.handler.origin_time
      response.receive_timestamp = receive_time + self.handler.gap
      response.transmit_timestamp = time
      # Kernel.puts response.inspect
      response
   end

   def receive_data data
      receive_time = ::Time.now
      request = NTP::Request.parse( data )
      response = make_response( request, receive_time )
      response.send do |data|
         # Kernel.puts data.unpack("C*").map{|x| sprintf "%.2x", x}.join
         send_data( data )
      end
   end

   def handler
      NTP::Server::Handler
   end

   def self.reader
      @@reader
   end

   def self.reader= reader
      @@reader = reader
   end

   def self.origin_time= origin_time
      @@origin_time = origin_time
   end

   def self.origin_time
      @@origin_time
   end

   def self.gap= gap
      Thread.new { $stderr.puts "#>#{gap.inspect}" }
      @@gap = gap.to_f
   end

   def self.gap
      @@gap
   end

   def self.update_gap
      self.reader.sync
      self.gap = self.reader.read_nonblock(1024)
   rescue IO::EAGAINWaitReadable
      retry
   end

   private

   def self.included klass
      Signal.trap("USR1") do
         update_gap
      end
   end
end
