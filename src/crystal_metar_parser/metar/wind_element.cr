class CrystalMetarParser::WindElement
  def initialize(@speed : Float64, @speed_max : Float64, @direction : Int32 = 0, @is_variable : Bool = false)
  end

  getter :speed, :speed_max, :direction, :is_variable
end
