require "./base"

class CrystalMetarParser::MetarCity < CrystalMetarParser::Base
  def initialize
    @code = ""
  end

  getter :code

  def decode_split(s)
    if s =~ /^([A-Z]{4})$/ && s != "AUTO" && s != "GRID" && s != "WNDS"
      @code = $1
    end
  end
end
