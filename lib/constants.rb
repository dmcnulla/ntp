module Net
  SERVER1 = 'sdgdccorp05.corp.intuit.net' #sdgdccorp05.corp.intuit.Net
  SERVER2 = 'us.pool.ntp.org'
  TIMEOUT = 60         #:nodoc:
  NTP_ADJ = 2208988800 #:nodoc:
  NTP_FIELDS = [ :byte1, :stratum, :poll, :precision, :delay, :delay_fb,
                 :disp, :disp_fb, :ident, :ref_time, :ref_time_fb, :org_time,
                 :org_time_fb, :recv_time, :recv_time_fb, :trans_time,
                 :trans_time_fb ]

  MODE = {
    0 => 'reserved',
    1 => 'symmetric active',
    2 => 'symmetric passive',
    3 => 'client',
    4 => 'server',
    5 => 'broadcast',
    6 => 'reserved for NTP control message',
    7 => 'reserved for private use'
  }

  STRATUM = {
    0 => 'unspecified or unavailable',
    1 => 'primary reference (e.g., radio clock)'
  }

  2.upto(15) do |i|
    STRATUM[i] = 'secondary reference (via NTP or SNTP)'
  end

  16.upto(255) do |i|
    STRATUM[i] = 'reserved'
  end

  REFERENCE_CLOCK_IDENTIFIER = {
    'LOCL' => 'uncalibrated local clock used as a primary reference for a subnet without external means of synchronization',
    'PPS'  => 'atomic clock or other pulse-per-second source individually calibrated to national standards',
    'ACTS' => 'NIST dialup modem service',
    'USNO' => 'USNO modem service',
    'PTB'  => 'PTB (Germany) modem service',
    'TDF'  => 'Allouis (France) Radio 164 kHz',
    'DCF'  => 'Mainflingen (Germany) Radio 77.5 kHz',
    'MSF'  => 'Rugby (UK) Radio 60 kHz',
    'WWV'  => 'Ft. Collins (US) Radio 2.5, 5, 10, 15, 20 MHz',
    'WWVB' => 'Boulder (US) Radio 60 kHz',
    'WWVH' => 'Kaui Hawaii (US) Radio 2.5, 5, 10, 15 MHz',
    'CHU'  => 'Ottawa (Canada) Radio 3330, 7335, 14670 kHz',
    'LORC' => 'LORAN-C radionavigation system',
    'OMEG' => 'OMEGA radionavigation system',
    'GPS'  => 'Global Positioning Service',
    'GOES' => 'Geostationary Orbit Environment Satellite'
  }

  LEAP_INDICATOR = {
    0 => 'no warning',
    1 => 'last minute has 61 seconds',
    2 => 'last minute has 59 seconds)',
    3 => 'alarm condition (clock not synchronized)'
  }

end