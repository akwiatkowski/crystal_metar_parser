require "./base"

class CrystalMetarParser::Temperature < CrystalMetarParser::Base
  def initialize
    @temperature = -255.0
    @dew = -255.0

    @humidity = -1.0
    @wind_chill = -255.0
    @wind_chill_us = -255.0
  end

  getter :temperature

  def degrees
    self.temperature
  end

  # Dew temperature
  getter :dew

  # Relative humidity
  getter :humidity

  # Wind chill index
  getter :wind_chill

  # US Wind chill index
  getter :wind_chill_us

  def decode_split(s)
    # Temperature in Celsius degrees
    if s =~ /^(M?)(\d{2})\/(M?)(\d{2})$/
      if $1 == "M"
        @temperature = -1.0 * $2.to_f
      else
        @temperature = $2.to_f
      end

      if $3 == "M"
        @dew = -1.0 * $4.to_f
      else
        @dew = $4.to_f
      end

      return
    end

    # shorter version
    if s =~ /^(M?)(\d{2})\/$/
      if $1 == "M"
        @temperature = -1.0 * $2.to_f
      else
        @temperature = $2.to_f
      end

      return
    end
  end

  def post_process(wind)
    calculate_humidity
    calculate_wind_chill(wind)
  end

  def calculate_humidity
    return if self.temperature == -255.0 || self.dew == -255.0

    # http://github.com/brandonh/ruby-metar/blob/master/lib/metar.rb
    # http://www.faqs.org/faqs/meteorology/temp-dewpoint/

    es0 = 6.11                # hPa
    t0 = 273.15               # kelvin
    td = self.dew + t0        # kelvin
    t = self.temperature + t0 # kelvin
    lv = 2500000              # joules/kg
    rv = 461.5                # joules*kelvin/kg
    e = es0 * Math.exp(lv / rv * (1.0 / t0 - 1.0 / td))
    es = es0 * Math.exp(lv / rv * (1.0 / t0 - 1.0 / t))
    rh = 100 * e / es

    @humidity = rh.round
  end

  def calculate_wind_chill(wind)
    return if self.temperature > 10 || wind.speed_kmh < 4.8

    # http://en.wikipedia.org/wiki/Wind_chill
    v = wind.speed
    ta = self.temperature

    @wind_chill_us = 13.12 +
      0.6215 * ta -
      11.37 * v +
      0.3965 * ta * v

    @wind_chill = (10.0 * Math.sqrt(v) - v + 10.5) * (33.0 - ta)
  end
end
