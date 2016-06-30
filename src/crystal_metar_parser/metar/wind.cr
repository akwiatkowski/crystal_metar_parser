require "./base"
require "./wind_element"
require "./wind_variable_element"

class CrystalMetarParser::Wind < CrystalMetarParser::Base
  def initialize
    @wind_elements = Array(CrystalMetarParser::WindElement).new
    @wind_variable_elements = [] of WindVariableElement
    @speed = -1.0
    @direction = -1
  end

  KNOTS_TO_METERS_PER_SECOND               = 1.85 / 3.6
  KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND = 1.0 / 3.6

  getter :speed, :direction

  def decode_split(s)
    decode_wind(s)
    decode_wind_variable(s)
  end

  def post_process
    recalculate_winds
  end

  # Wind parameters in meters per second
  def decode_wind(s)
    if s =~ /(\d{3})(\d{2})G?(\d{2})?(KT|MPS|KMH)/
      # different units
      wind = case $4
             when "KT"
               $2.to_f * KNOTS_TO_METERS_PER_SECOND
             when "MPS"
               $2.to_f
             when "KMH"
               $2.to_f * KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND
             else
               0.0
             end

      begin
        wind_max = case $4
                   when "KT"
                     $3.to_s.to_f * KNOTS_TO_METERS_PER_SECOND
                   when "MPS"
                     $3.to_s.to_f
                   when "KMH"
                     $3.to_s.to_f * KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND
                   else
                     0.0
                   end
      rescue
        wind_max = wind
      end

      # wind_max is not less than normal wind
      if wind_max < wind || wind_max == 0.0
        wind_max = wind
      end

      w = CrystalMetarParser::WindElement.new(
        speed: wind,
        speed_max: wind_max,
        direction: $1.to_i,
        is_variable: false
      )
      @wind_elements << w
    end

    # variable/unknown direction
    if s =~ /VRB(\d{2})(KT|MPS|KMH)/
      wind = case $2
             when "KT"
               $1.to_f * KNOTS_TO_METERS_PER_SECOND
             when "MPS"
               $1.to_f
             when "KMH"
               $1.to_f * KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND
             else
               nil
             end

      unless wind.nil?
        w = CrystalMetarParser::WindElement.new(
          speed: wind,
          speed_max: wind,
          direction: -1,
          is_variable: true
        )
        @wind_elements << w
      end
    end
  end

  # Variable wind direction
  def decode_wind_variable(s)
    if s =~ /(\d{3})V(\d{3})/
      w = CrystalMetarParser::WindVariableElement.new($1.to_i, $2.to_i)
      @wind_variable_elements << w
    end
  end

  # Calculate wind parameters, some metar string has multiple winds recorded
  def recalculate_winds
    wind_sum = @wind_elements.sum { |w| w.speed }
    @speed = wind_sum.to_f / @wind_elements.size if @wind_elements.size > 0

    if @wind_elements.size == 1
      @direction = @wind_elements.first.direction
    end
  end

  # Wind speed in knots
  def speed_knots
    return self.speed / KNOTS_TO_METERS_PER_SECOND
  end

  # Wind speed in KM/H
  def speed_kmh
    return self.speed / KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND
  end

  # Meters per second
  def mps
    self.speed
  end

  # Kilometers per hour
  def kmh
    self.speed_kmh
  end

  # Knots
  def knots
    self.speed_knots
  end
end
