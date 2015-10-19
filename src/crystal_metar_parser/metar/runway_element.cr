class CrystalMetarParser::RunwayElement
  def initialize(_runway, _visibility, _change = "")
    @runway = _runway
    @visibility = _visibility
    @change = _change
  end

  getter :runway, :visibility, :chage
end
