class CrystalMetarParser::CloudElement
  def initialize(@coverage : Int32, _bottom : String = "", _vertical_visibility : String = "")
    unless "" == _bottom.to_s
      @bottom = _bottom.to_i * 30
    else
      @bottom = -1
    end

    unless "" == _vertical_visibility.to_s
      @vertical_visibility = _vertical_visibility.to_i * 30
    else
      @vertical_visibility = -1
    end
  end

  getter :coverage, :bottom, :vertical_visibility
end
