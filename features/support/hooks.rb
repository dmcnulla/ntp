Before('@ntp') do |scenario|
  @server = NTP::Server::Control.new
  @server.start(SERVER_PORT)
  begin
    status = @server.status
  end until /listen/ =~ status
end

After('@ntp') do |scenario|
  @server.stop
  @server.status
end
