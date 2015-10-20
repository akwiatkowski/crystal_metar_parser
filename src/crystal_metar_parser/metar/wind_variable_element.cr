class CrystalMetarParser::WindVariableElement
  def initialize(_direction_from, _direction_to)
    @direction_from = _direction_from # as Int32
    @direction_to = _direction_to # as Int32
    @direction = (@direction_from + @direction_to) / 2
  end

  getter :direction_from, :direction_to, :direction
end
