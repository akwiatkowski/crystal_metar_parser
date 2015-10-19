class CrystalMetarParser::WindPartial
  def initialize(_speed, _speed_max, _direction, _is_variable = false)
    @speed = _speed as Float64
    @speed_max = _speed_max
    @direction = _direction
    @is_variable = _is_variable
  end

  getter :speed, :speed_max, :direction, :is_variable

end
