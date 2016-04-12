Before do |scenario|
  @server = NTP::Server::Control.new
  @server.start(SERVER_PORT)
  begin
    status = @server.status
  end until /listen/ =~ status
end

After do |scenario|
  @server.stop
  @server.status
end
