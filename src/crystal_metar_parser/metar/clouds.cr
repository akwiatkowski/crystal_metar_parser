require "./base"
require "./cloud_element"

class CrystalMetarParser::Clouds < CrystalMetarParser::Base
  # Cloud level - clear sky
  CLOUD_CLEAR = (0 * 100.0 / 8.0).round.to_i
  # Cloud level - few clouds
  CLOUD_FEW = (1.5 * 100.0 / 8.0).round.to_i
  # Cloud level - scattered
  CLOUD_SCATTERED = (3.5 * 100.0 / 8.0).round.to_i
  # Cloud level - broken
  CLOUD_BROKEN = (6 * 100.0 / 8.0).round.to_i
  # Cloud level - overcast
  CLOUD_OVERCAST = (8 * 100.0 / 8.0).round.to_i
  # Cloud level - not significant
  CLOUD_NOT_SIGN = (0.5 * 100.0 / 8.0).round.to_i

  def initialize
    @clouds = [] of CloudElement
    @clouds_max = 0
  end

  getter :clouds, :clouds_max

  def decode_split(s)
    if s =~ /^(SKC|FEW|SCT|BKN|OVC|NSC)(\d{3}?)$/
      cl = case $1
           when "SKC"
             CLOUD_CLEAR
           when "FEW"
             CLOUD_FEW
           when "SCT"
             CLOUD_SCATTERED
           when "BKN"
             CLOUD_BROKEN
           when "OVC"
             CLOUD_OVERCAST
           when "NSC"
             CLOUD_NOT_SIGN
           else
             CLOUD_CLEAR
           end

      @clouds << CrystalMetarParser::CloudElement.new(cl, $2, "")
      # @clouds.uniq!
    end

    # obscured by clouds, vertical visibility
    if s =~ /^(VV)(\d{3}?)$/
      @clouds << CrystalMetarParser::CloudElement.new(CLOUD_OVERCAST, "", $2)

      # @clouds.uniq!
    end

    if s =~ /^(CAVOK)$/
      # everything is awesome :)
    end
  end

  # Calculate numeric description of clouds
  def post_process
    @clouds.each do |c|
      @clouds_max = c.coverage if @clouds_max < c.coverage
    end
  end
end
