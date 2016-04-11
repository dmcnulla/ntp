require 'ntp/server/base'
require 'ruby-fifo'

class NTP::Server::Control
   DEFAULT_PORT = 17890

   def usage
      "Usage: ntp-mock-server [start|stop|restart|status|time <time>|reset]"
   end

   def status
      send_command('status')
      status = read(@client_in)
      status || "not running"
   end

   def start port = DEFAULT_PORT
      fork do
         Process.setsid
         NTP::Server::Base.new(port || DEFAULT_PORT).start
      end
      read(@client_in, 5)
   end

   def stop
      send_command('stop')

      s = true
      begin
         Timeout::timeout(5) do
            while s do
               send_command('status')
               s = read(@client_in)
            end
         end
      rescue Timeout::Error
      end

      if s
         "failed to stop: status #{s}"
      else
         "stopped"
      end
   end

   def restart
      [ stop, start ].join("\n")
   end

   def time time
      send_command("time #{time}")
   end

   def reset
      send_command('reset')
   end

   private

   def send_command data
      @client_out.puts data
      @client_out.to_io.sync
   end

   def read client_in, timeout = 1
      begin
         Timeout::timeout(timeout) { client_in.gets }
      rescue Timeout::Error
      end
   end

   def initialize
      @client_out = Fifo.new(Dir.tmpdir + '/ntp-mock-server-in', :w, :nowait)
      @client_in = Fifo.new(Dir.tmpdir + '/ntp-mock-server-out', :r, :nowait)
   end
end
