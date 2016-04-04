# NTP Mock Server

[![Dependency Status](https://gemnasium.com/majioa/ntp-mock-server.png)](https://gemnasium.com/majioa/ntp-mock-server)
[![Gem Version](https://badge.fury.io/rb/ntp-mock-server.png)](http://rubygems.org/gems/ntp-mock-server)

## Usage
### in ruby script

Install gem from `github`, by adding the gem line into the **Gemfile** as follows:

```ruby
gem 'ntp-mock-server', github: 'dmcnulla/ntp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flickr_oblak

Add to your script:

    require 'ntp' # NOTE it automatically includes 'net/ntp' gem

    # create a new server instance
    server = NTP::Server::Control.new

    # starting the server on 12345-th port.
    server.start(12345)
    # => "started NTP mock server on localhost:12345."

    # get a time from the server
    Net::NTP::get('127.0.0.1', 12345).time # => time...

    # set base time for the server
    server.time("2000/01/01 01:00")

    # get a new rebased time from the server
    Net::NTP::get('127.0.0.1', 12345).time # => "2000/01/01 01:05"

    # stop the server. NOTE since the server is bind to another process, it shall be explicitly stopped.  
    server.stop
    # => "stopped"

### From a command line

You can control the server by using a command line interface as follows:

    # start the server
    $ ntp-mock-server start

    # setb server's base time
    $ ntp-mock-server time "2000/01/01 01:00"

    # stop the server
    $ ntp-mock-server stop

Issue the CLI application without a command to view all available ones:

    $ ntp-mock-server
    Usage: ntp-mock-server [start|stop|restart|status|time <time>|reset]
    
## Contributing

1. Fork it ( https://github.com/dmcnulla/ntp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See `LICENSE.txt` file.
