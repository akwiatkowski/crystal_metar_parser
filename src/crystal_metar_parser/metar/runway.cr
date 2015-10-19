require "./base"
require "./runway_element"

class CrystalMetarParser::Runway < CrystalMetarParser::Base
  def initialize
    @runways = [] of RunwayElement
  end

  getter :runways

  def decode_split(s)
    # TODO add variable vis. http://stoivane.iki.fi/metar/

    if s =~ /R(.{2})\/P(\d{4})(.)/
      @runways << CrystalMetarParser::RunwayElement.new($1, $2.to_i, $3)
    end
  end
end
