class CrystalMetarParser::MetarSpecialElement
  def initialize(
                 _intensity,
                 _descriptor,
                 _precipitation,
                 _obscuration,
                 _misc,

                 _intensity_raw,
                 _descriptor_raw,
                 _precipitation_raw,
                 _obscuration_raw,
                 _misc_raw)
    @intensity = _intensity
    @descriptor = _descriptor
    @precipitation = _precipitation
    @obscuration = _obscuration
    @misc = _misc

    @intensity_raw = _intensity_raw
    @descriptor_raw = _descriptor_raw
    @precipitation_raw = _precipitation_raw
    @obscuration_raw = _obscuration_raw
    @misc_raw = _misc_raw
  end

  getter :intensity, :descriptor, :precipitation, :obscuration, :misc
  getter :intensity_raw, :descriptor_raw, :precipitation_raw, :obscuration_raw, :misc_raw
end
