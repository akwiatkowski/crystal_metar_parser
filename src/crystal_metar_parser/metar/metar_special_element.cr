class CrystalMetarParser::MetarSpecialElement
  def initialize(
                 @intensity : String,
                 @descriptor : String,
                 @precipitation : String,
                 @obscuration : String,
                 @misc : String,

                 @intensity_raw : String,
                 @descriptor_raw : String,
                 @precipitation_raw : String,
                 @obscuration_raw : String,
                 @misc_raw : String)
  end

  getter :intensity, :descriptor, :precipitation, :obscuration, :misc
  getter :intensity_raw, :descriptor_raw, :precipitation_raw, :obscuration_raw, :misc_raw
end
