require 'eventmachine'

class NTP::Server::Base
   attr_accessor :host, :port, :pipe_in, :pipe_out, :pid,
       :command_reader, :command_writer, :answer_reader, :answer_writer

   def initialize(port = 123)
      self.pipe_in = ::Fifo.new(Dir.tmpdir + '/ntp-mock-server-in', :r, :nowait)
      self.pipe_out = ::Fifo.new(Dir.tmpdir + '/ntp-mock-server-out', :w,
         :nowait)
      self.host = 'localhost'
      self.port = port
      (self.command_reader, self.command_writer) = IO.pipe
      (self.answer_reader, self.answer_writer) = IO.pipe
      handler.origin_time = Time.now
      handler.gap = 0
   end

   # runs the server
   def start
      self.pid = fork do
         self.command_writer.close
         self.answer_reader.close
         self.handler.reader = self.command_reader
         self.handler.writer = self.answer_writer
         ::EventMachine::run do
            ::EventMachine::open_datagram_socket self.host, self.port,
               self.handler
        end
      end
      self.command_reader.close
      self.answer_writer.close
      self.pipe_out.puts "started NTP mock server on #{host}:#{port}."
      process_queue
   end

   # returns handler constant
   def handler
      ::NTP::Server::Handler
   end

   private

   # enters to the processing queue loop
   def process_queue
      while true
         self.pipe_in.to_io.sync
         message = self.pipe_in.gets
         # puts message
         case message
         when /stop/
            stop
         when /status/
            self.pipe_out.puts(status)
         when /time/
            /time (?<time_string>.*)/ =~ message
            begin
               time = Time.parse(time_string)
            rescue ::ArgumentError => e
               puts("can't set invalid time in message: #{message} by " +
                  "#{e.message}")
            else
               change_time(time)
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
      Process.exit(true)
   end

   # sets a new time for the NTP server to base future responses
   def change_time(new_time)
      update_gap(new_time.utc - Time.now.utc)
   end

   # sets the time to current time to base future responses
   def reset
      update_gap(0)
   end

   def status
      'listening...'
   end

   def puts *args
      Kernel.puts *args
   end

   def update_gap gap
      send_gap(gap)
      wait_answer
   rescue ::Timeout::Error
      retry
   rescue ::NameError
      Kernel.puts IO.constants.inspect
      retry
   end

   def send_gap gap
      begin
         self.command_writer.puts(gap)
      rescue ::Errno::EPIPE
         # TODO check and restore child server part
      end
      self.command_writer.sync
      Process.kill("USR1", self.pid)
   end

   def wait_answer
      ::Timeout.timeout(5) do
         begin
            self.answer_reader.sync
            self.answer_reader.read_nonblock(1024)
         rescue ::IO::WaitReadable, ::IO::EAGAINWaitReadable
            ::IO.select([self.answer_reader])
            retry
         rescue ::EOFError
         end
      end
   end

   # only used for practing the cukes
   # def get_time
   #   @time
   # end
end
