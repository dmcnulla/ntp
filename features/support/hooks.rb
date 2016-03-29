Before do |scenario|
  @server = Ntp::Server.new(SERVER_PORT)
  @server.start
end

After do |scenario|
  @server.stop
end
