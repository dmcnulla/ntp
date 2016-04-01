require 'net/ntp'

module NTP
   Net::NTP::STRATUM.merge!( { 16 => 'non-synchronized' } )

   class ClockId
      def data
         if @stratum < 2
            "#{@id}\0".split('').map(&:ord).pack("C4")
         else
            # as IP
            @id.split('.').map(&:to_i).pack("C4")
         end
      end

      def initialize stratum = 1, id
         @stratum = stratum
         @id = Net::NTP::REFERENCE_CLOCK_IDENTIFIER.invert[ id ] || id
      end
   end

   class Time
      attr_reader :seconds, :fraction

      def timestamp
         [ seconds, fraction ].pack( "NB32" )
      end

      def short
         [ seconds, fraction ].pack( "nB16" )
      end

      def time
         t = ( seconds - Net::NTP::NTP_ADJ ).to_f + bin2frac( fraction )
         ::Time.at( t )
      end

      private

      def bin2frac(bin) #:nodoc:
         frac = 0

         bin.reverse.split("").each do |b|
            frac = ( frac + b.to_i ) / 2.0
         end

         frac
      end

      def initialize *args
         if args.size > 1
            @seconds = args.shift
            @fraction = args.shift

            # w/a
            if @seconds < Net::NTP::NTP_ADJ
               @seconds += Net::NTP::NTP_ADJ
            end
         else
            if args[ 0 ].is_a?( NTP::Time )
               @seconds = args[ 0 ].seconds
               @fraction = args[ 0 ].fraction
            else
               time =
               case args[ 0 ]
               when String
                  self.class.parse( args[ 0 ] )
               when ::Time
                  args[ 0 ].utc
               when Float, Integer
                  ::Time.at( args[ 0 ] - Net::NTP::NTP_ADJ )
               else
                  ::Time.now.utc
               end

               @seconds = time.to_i + Net::NTP::NTP_ADJ
               @fraction = Net::NTP.send( :frac2bin, time.to_f - time.to_i )
            end
         end
      end
   end

   class Request
      attr_reader :leap_indicator, :mode, :timestamp
      attr_accessor :version_number

      def leap_indicator= leap_indicator
         @leap_indicator =
         if leap_indicator.is_a?( String )
            Net::NTP::Response::LEAP_INDICATOR.invert[ leap_indicator ]
         else
            leap_indicator
         end
      end

      def mode= mode
         @mode =
         if mode.is_a?( String )
            Net::NTP::Response::MODE.invert[ mode ]
         else
            mode
         end
      end

      def timestamp= timestamp
         @timestamp = NTP::Time.new( timestamp )
      end

      def self.parse data
         args = data.unpack( "C C3 N10 B32" )
         request = Request.new
         request.leap_indicator = ( args[ 0 ] & 0xc0 ) >> 6
         request.version_number = ( args[ 0 ] & 0x38 ) >> 3
         request.mode = args[ 0 ] & 0x7
         request.timestamp = NTP::Time.new( args[ -2 ], args[ -1 ] )
         request
      end
   end

   class Response < Net::NTP::Response

      attr_writer :version_number, :poll_interval, :precision,
         :root_dispersion

      def leap_indicator= leap_indicator
         @leap_indicator_text = leap_indicator
         @leap_indicator = Net::NTP::LEAP_INDICATOR.invert[ leap_indicator ]
      end

      def mode= mode
         @mode_text ||= mode
         @mode ||= Net::NTP::MODE.invert[ mode ]
      end

      def stratum= stratum
         @stratum_text ||= stratum
         @stratum = Net::NTP::STRATUM.invert[ stratum ]
      end

      def reference_clock_identifier= reference_clock_identifier
         @reference_clock_identifier =
         NTP::ClockId.new( @stratum, reference_clock_identifier )
      end

      def root_delay= root_delay
         @root_delay = NTP::Time.new( root_delay )
      end

      def reference_timestamp= reference_timestamp
         @reference_timestamp = NTP::Time.new( reference_timestamp )
      end

      def originate_timestamp= originate_timestamp
         @originate_timestamp = NTP::Time.new( originate_timestamp )
      end

      def receive_timestamp= receive_timestamp
         @receive_timestamp = NTP::Time.new( receive_timestamp )
      end

      def transmit_timestamp= transmit_timestamp
         @transmit_timestamp = NTP::Time.new( transmit_timestamp )
      end

      def send &block
         data = self.compile
         yield "#{data[0...40]}#{transmit_timestamp.timestamp}"
      end

      protected

      def raw_data
         if ! @raw_data
            @packetdata = []
            NTP_FIELDS.each do |field|
               @packetdata.push( @packet_data_by_field[field] )
            end

            @raw_data = @packetdata.pack( "a C3   n B16 n B16 H8   N B32 N B32   N B32 N B32" )
         end

         @raw_data
      end

      def compile
         data = [
            ( ( @leap_indicator & 0x3 ) << 6 |
              ( @version_number & 0x7 ) << 3 |
              ( @mode & 0x7 ) ),
            @stratum,
            @poll_interval,
            @precision,
            @root_delay.short,
            @root_dispersion.short,
            @reference_clock_identifier.data,
            @reference_timestamp.timestamp,
            @originate_timestamp.timestamp,
            @receive_timestamp.timestamp,
            @transmit_timestamp.timestamp,
         ]
         data.pack( "C4 A4 A4 A4 A8 A8 A8 A8" )
      end

      private

      def initialize
         super(nil, ::Time.now)
      end
   end
end

require 'ntp/server'
