Before do |scenario|
  @server = NTP::Server::Control.new
  @server.start(SERVER_PORT)
end

After do |scenario|
  @server.stop
end
