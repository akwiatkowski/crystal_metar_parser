require "./metar/base"
require "./metar/wind"
require "./metar/visibility"
require "./metar/metar_city"

module CrystalMetarParser
  class Metar

    DEFAULT_TIME_INTERVAL = 30 * 60

    def initialize(_raw, options = {} of String => String)
      @raw = _raw.to_s.gsub(/\s/, ' ').strip
      @raw_splits = @raw.split(' ')

      @year = Time.utc_now.year
      @month = Time.utc_now.month

      @visibility = CrystalMetarParser::Visibility.new
      @city = CrystalMetarParser::MetarCity.new
      @wind = CrystalMetarParser::Wind.new

      decode
      post_process
    end

    getter :visibility
    getter :city
    getter :wind

    def decode
      @raw_splits.each do |s|
        decode_split(s)
      end
    end

    def decode_split(s)
      @wind.decode_split(s)
      @visibility.decode_split(s)
      @city.decode_split(s)
    end

    def post_process
      @wind.post_process
    end


  end
end
