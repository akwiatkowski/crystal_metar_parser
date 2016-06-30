require "./base"
require "./metar_special_element"

class CrystalMetarParser::MetarSpecials < CrystalMetarParser::Base
  # description http://www.ofcm.gov/fmh-1/pdf/H-CH8.pdf

  @snow_metar : Float64
  @rain_metar : Float64

  def initialize
    @specials = Array(MetarSpecialElement).new
    @snow_metar = -1.0
    @rain_metar = -1.0
  end

  getter :specials
  getter :snow_metar
  getter :rain_metar

  def decode_split(s)
    decode_specials(s)
  end

  # Calculate numeric description of clouds
  def post_process
    calculate_rain_and_snow
  end

  def decode_specials(s)
    if s =~ /^(VC|\-|\+|\b)(MI|PR|BC|DR|BL|SH|TS|FZ|)(DZ|RA|SN|SG|IC|PE|GR|GS|UP|)(BR|FG|FU|VA|DU|SA|HZ|PY|)(PO|SQ|FC|SS|)$/
      intensity = case $1
                  when "VC"
                    "in the vicinity"
                  when "+"
                    "heavy"
                  when "-"
                    "light"
                  else
                    "moderate"
                  end

      descriptor = case $2
                   when "MI"
                     "shallow"
                   when "PR"
                     "partial"
                   when "BC"
                     "patches"
                   when "DR"
                     "low drifting"
                   when "BL"
                     "blowing"
                   when "SH"
                     "shower"
                   when "TS"
                     "thunderstorm"
                   when "FZ"
                     "freezing"
                   else
                     ""
                   end

      precipitation = case $3
                      when "DZ"
                        "drizzle"
                      when "RA"
                        "rain"
                      when "SN"
                        "snow"
                      when "SG"
                        "snow grains"
                      when "IC"
                        "ice crystals"
                      when "PE"
                        "ice pellets"
                      when "GR"
                        "hail"
                      when "GS"
                        "small hail/snow pellets"
                      when "UP"
                        "unknown"
                      else
                        ""
                      end

      obscuration = case $4
                    when "BR"
                      "mist"
                    when "FG"
                      "fog"
                    when "FU"
                      "smoke"
                    when "VA"
                      "volcanic ash"
                    when "DU"
                      "dust"
                    when "SA"
                      "sand"
                    when "HZ"
                      "haze"
                    when "PY"
                      "spray"
                    else
                      ""
                    end

      misc = case $5
             when "PO"
               "dust whirls"
             when "SQ"
               "squalls"
             when "FC"
               "funnel cloud/tornado/waterspout"
             when "SS"
               "duststorm"
             else
               ""
             end

      # when no sensible data do nothing
      return if descriptor == "" && precipitation == "" && obscuration == "" && misc == ""

      @specials << CrystalMetarParser::MetarSpecialElement.new(
        intensity,
        descriptor,
        precipitation,
        obscuration,
        misc,

        $1,
        $2,
        $3,
        $4,
        $5
      )
    end
  end

  # Calculate precipitation in self defined units and aproximated real world units
  def calculate_rain_and_snow
    @snow_metar = 0.0
    @rain_metar = 0.0

    self.specials.each do |s|
      new_rain = 0.0
      new_snow = 0.0
      coefficient = 1.0
      case s.precipitation
      when "drizzle"
        new_rain = 5.0
      when "rain"
        new_rain = 10.0
      when "snow"
        new_snow = 10.0
      when "snow grains"
        new_snow = 5.0
      when "ice crystals"
        new_snow = 1.0
        new_rain = 1.0
      when "ice pellets"
        new_snow = 2.0
        new_rain = 2.0
      when "hail"
        new_snow = 3.0
        new_rain = 3.0
      when "small hail/snow pellets"
        new_snow = 1.0
        new_rain = 1.0
      end

      case s.intensity
      when "in the vicinity"
        coefficient = 1.5
      when "heavy"
        coefficient = 3.0
      when "light"
        coefficient = 0.5
      when "moderate"
        coefficient = 1.0
      end

      snow = new_snow * coefficient
      rain = new_rain * coefficient

      if @snow_metar < snow
        @snow_metar = snow
      end
      if @rain_metar < rain
        @rain_metar = rain
      end
    end

    # http://www.ofcm.gov/fmh-1/pdf/H-CH8.pdf page 3
    # 10 units means more than 0.3 (I assume 0.5) inch per hour, so:
    # 10 units => 0.5 * 25.4mm
    real_world_coefficient = 0.5 * 25.4 / 10.0
    @snow_metar *= real_world_coefficient
    @rain_metar *= real_world_coefficient
  end
end
