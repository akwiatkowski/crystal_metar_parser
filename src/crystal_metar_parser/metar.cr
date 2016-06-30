require "./metar/base"

require "./metar/metar_city"
require "./metar/metar_time"

require "./metar/temperature"
require "./metar/wind"
require "./metar/visibility"
require "./metar/pressure"
require "./metar/clouds"

require "./metar/metar_specials"
require "./metar/runway"
require "./metar/metar_other"

class CrystalMetarParser::Metar
  DEFAULT_TIME_INTERVAL = 30 * 60.as(Int32)

  @raw : String
  @raw_splits : Array(String)
  @year : Int32
  @month : Int32
  @time_interval : Int32

  def initialize(
                 @raw : String,
                 @year : Int32 = Time.utc_now.year,
                 @month : Int32 = Time.utc_now.month,
                 @time_interval : Int32 = DEFAULT_TIME_INTERVAL)
    @raw = @raw.to_s.gsub(/\s/, ' ').strip
    @raw_splits = @raw.split(' ')

    # process options
    @year = year.to_s.to_i unless year.is_a?(Nil)
    @month = month.to_s.to_i unless month.is_a?(Nil)
    @time_interval = time_interval.to_s.to_i unless time_interval.is_a?(Nil)

    @city = CrystalMetarParser::MetarCity.new
    @time = CrystalMetarParser::MetarTime.new(@year, @month, @time_interval)

    @temperature = CrystalMetarParser::Temperature.new
    @wind = CrystalMetarParser::Wind.new
    @visibility = CrystalMetarParser::Visibility.new
    @pressure = CrystalMetarParser::Pressure.new
    @clouds = CrystalMetarParser::Clouds.new

    @specials = CrystalMetarParser::MetarSpecials.new
    @runway = CrystalMetarParser::Runway.new
    @other = CrystalMetarParser::MetarOther.new

    decode
    post_process
  end

  getter :raw
  getter :city
  getter :time

  getter :visibility
  getter :wind
  getter :temperature
  getter :pressure
  getter :clouds

  getter :specials
  getter :runway
  getter :other

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
    @clouds.decode_split(s)

    @specials.decode_split(s)
    @runway.decode_split(s)
    @other.decode_split(s)
  end

  def post_process
    @wind.post_process
    @temperature.post_process(@wind)
    @specials.post_process
    @clouds.post_process
  end

  def to_hash
    {
      city:           @city.code,
      time_from:      @time.time_from,
      time_to:        @time.time_to,
      temperature:    @temperature.degrees,
      dew:            @temperature.dew,
      humidity:       @temperature.humidity,
      wind_chill:     @temperature.wind_chill,
      wind:           @wind.speed,
      wind_direction: @wind.direction,
      visibility:     @visibility.visibility,
      pressure:       @pressure.pressure,
      clouds:         @clouds.clouds_max,
      rain_metar:     @specials.rain_metar,
      snow_metar:     @specials.snow_metar,
      station_precip: @other.station,
      station_auto:   @other.station_auto,
    }
  end
end
