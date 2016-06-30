class CrystalMetarParser::WindVariableElement
  @direction : Int32

  def initialize(@direction_from : Int32, @direction_to : Int32)
    @direction = (@direction_from + @direction_to) / 2
  end

  getter :direction_from, :direction_to, :direction
end
