require "./base"

class CrystalMetarParser::Visibility < CrystalMetarParser::Base
  # max visibility
  MAX_VISIBILITY = 10_000

  # If visibility is greater than this it assume it is maximum
  NEARLY_MAX_VISIBILITY = 9_500

  @visibility : Int32

  def initialize
    @visibility = -1
  end

  def reset
    @visibility = -1
  end

  getter :visibility

  def decode_split(s)
    # Visibility in meters

    # Europa
    if s =~ /^(\d{4})$/
      @visibility = $1.to_i
    end

    # US
    if s =~ /^(\d{1,3})\/?(\d{0,2})SM$/
      if $2 == ""
        @visibility = ($1.to_f * 1600.0).to_i
      else
        @visibility = ($1.to_f * 1600.0 / $2.to_f).to_i
      end
    end

    # constant max value
    if @visibility.to_i >= NEARLY_MAX_VISIBILITY
      @visibility = MAX_VISIBILITY
    end

    if s =~ /^(CAVOK)$/
      @visibility = MAX_VISIBILITY
    end
  end

  def to_hash
    {visibility: @visibility}
  end
end
