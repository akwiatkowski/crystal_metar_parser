require "./base"

class CrystalMetarParser::MetarTime < CrystalMetarParser::Base
  def initialize(
                 @year : Int32,
                 @month : Int32,
                 @time_interval : Int32 = CrystalMetarParser::Metar::DEFAULT_TIME_INTERVAL)
    @time = Time.now
  end

  getter :year, :month, :time, :time_interval

  def decode_split(s)
    if s =~ /(\d{2})(\d{2})(\d{2})Z/
      @time = Time.new(self.year, self.month, $1.to_i, $2.to_i, $3.to_i, 0, 0, Time::Kind::Utc)
    end
  end

  def time_from
    self.time
  end

  def time_to
    self.time_from + Time::Span.new(0, 0, self.time_interval)
  end
end
