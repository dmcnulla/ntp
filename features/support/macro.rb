module Macro
  def get_time
    begin
      Net::NTP.get('localhost', SERVER_PORT).time
    rescue Errno::ECONNREFUSED
      retry
    end
  end
end

World(Macro)

