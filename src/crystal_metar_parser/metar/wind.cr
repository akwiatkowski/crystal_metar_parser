require "./base"
require "./wind_partial"

class CrystalMetarParser::Wind < CrystalMetarParser::Base
  def initialize
    @winds_partials = [] of WindPartial
    @speed = -1.0
    @direction = -1
  end

  KNOTS_TO_METERS_PER_SECOND               = 1.85 / 3.6
  KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND = 1.0 / 3.6

  getter :speed, :direction

  def decode_split(s)
    decode_wind(s)

    # decode_wind_variable(s)
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

      #     wind_max = case $4
      #                when "KT"
      #                  $3.to_f * KNOTS_TO_METERS_PER_SECOND
      #                when "MPS"
      #                  $3.to_f
      #                when "KMH"
      #                  $3.to_f * KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND
      #                else
      #                  0.0
      #                end

      #     # wind_max is not less than normal wind
      #     if wind_max < wind || wind_max == 0.0
      #       wind_max = wind
      #     end

      w = CrystalMetarParser::WindPartial.new(wind, wind, $1.to_i, false)
      @winds_partials << w
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

      w = CrystalMetarParser::WindPartial.new(wind, wind, -1, true)
      @winds_partials << w
    end
  end

  #  # Variable wind direction
  #  def decode_wind_variable(s)
  #    if s =~ /(\d{3})V(\d{3})/
  #     @winds_variable_directions << {
  #       :wind_variable_direction_from => $1.to_i,
  #       :wind_variable_direction_to   => $2.to_i,
  #       :wind_direction               => ($1.to_i + $2.to_i) / 2,
  #       :wind_variable                => true,
  #     }
#
  #    end
  #  end

  # Calculate wind parameters, some metar string has multiple winds recorded
  def recalculate_winds
    wind_sum = @winds_partials.sum { |w| w.speed }
    @speed = wind_sum.to_f / @winds_partials.size if @winds_partials.size > 0

    if @winds_partials.size == 1
      @direction = @winds_partials.first.direction
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
