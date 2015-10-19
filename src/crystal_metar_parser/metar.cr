require "./metar/base"

require "./metar/metar_city"
require "./metar/metar_time"

require "./metar/temperature"
require "./metar/wind"
require "./metar/visibility"
require "./metar/pressure"

module CrystalMetarParser
  class Metar

    DEFAULT_TIME_INTERVAL = 30 * 60

    def initialize(_raw, options = {} of String => String)
      @raw = _raw.to_s.gsub(/\s/, ' ').strip
      @raw_splits = @raw.split(' ')

      @year = Time.utc_now.year
      @month = Time.utc_now.month
      @time_interval = DEFAULT_TIME_INTERVAL

      @city = CrystalMetarParser::MetarCity.new
      @time = CrystalMetarParser::MetarTime.new(@year, @month, @time_interval)

      @temperature = CrystalMetarParser::Temperature.new
      @wind = CrystalMetarParser::Wind.new
      @visibility = CrystalMetarParser::Visibility.new
      @pressure = CrystalMetarParser::Pressure.new



      decode
      post_process
    end

    getter :city
    getter :time

    getter :visibility
    getter :wind
    getter :temperature
    getter :pressure

    def decode
      @raw_splits.each do |s|
        decode_split(s)
      end
    end

    def decode_split(s)
      @city.decode_split(s)
      @time.decode_split(s)

      @temperature.decode_split(s)
      @wind.decode_split(s)
      @visibility.decode_split(s)
      @pressure.decode_split(s)

    end

    def post_process
      @wind.post_process
      @temperature.post_process(@wind)
    end


  end
end
