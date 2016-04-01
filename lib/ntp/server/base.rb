require 'eventmachine'

class NTP::Server::Base
   attr_accessor :host, :port, :pipe_in, :pipe_out, :pid,
       :gap_reader, :gap_writer

   def initialize(port = 123)
      self.pipe_in = Fifo.new('ntp-mock-server-in', :r, :nowait)
      self.pipe_out = Fifo.new('ntp-mock-server-out', :w, :nowait)
      self.host = 'localhost'
      self.port = port
      (self.gap_reader, self.gap_writer) = IO.pipe
      handler.origin_time = Time.now
      handler.gap = 0
   end

   # runs the server
   def start
      # puts "################"
      self.pid = fork do
        self.gap_writer.close
        self.handler.reader = self.gap_reader
        EventMachine::run do
          EventMachine::open_datagram_socket self.host, self.port, self.handler
        end
      end
      self.gap_reader.close
      self.pipe_out.puts "started NTP mock server on #{host}:#{port}."
      process_queue
   end

   def handler
       NTP::Server::Handler
   end

   private

   def process_queue
      while true
         message = self.pipe_in.gets
         # puts message
         case message
         when /stop/
            stop
         when /status/
            self.pipe_out.puts(status)
         when /time/
            /time (?<time>.*)/ =~ message
            begin
               change_time(Time.parse(time))
            rescue ArgumentError
               puts "can't set invalid time"
            end
         when /reset/
            reset
         end
      end
   end

   # stops the server
   def stop
      Process.kill("HUP", self.pid)
      Process.wait2
      # puts "$$$$$$$$$$$$$$$$"
      Process.exit(true)
   end

   # sets a new time for the NTP server to base future responses
   def change_time(new_time)
      send_gap(new_time.utc - Time.now.utc)
      # puts "Set time base to #{new_time.utc}..."
   end

   # sets the time to current time to base future responses
   def reset
      send_gap(0)
      # puts "Reset time base..."
   end

   def status
      'listening...'
   end

   def puts *args
      Kernel.puts *args
   end

   def send_gap gap
      self.gap_writer.puts(gap)
      self.gap_writer.sync
      Process.kill("USR1", self.pid)
   end

   # only used for practing the cukes
   # def get_time
   #   @time
   # end
end
