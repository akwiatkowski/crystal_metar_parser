require "./base"

class CrystalMetarParser::MetarTime < CrystalMetarParser::Base

  def initialize(_year, _month, _time_interval = 30*60)
    @year = _year
    @month = _month
    @time = Time.now
    @time_interval = _time_interval
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
    self.time_from + self.time_interval
  end

end
