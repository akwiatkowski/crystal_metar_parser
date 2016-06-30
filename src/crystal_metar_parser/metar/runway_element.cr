class CrystalMetarParser::RunwayElement
  def initialize(@runway : String, @visibility : Int32, @change : String = "")
  end

  getter :runway, :visibility, :chage
end
