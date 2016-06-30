module CrystalMetarParser
  class Parser
    def self.parse(
                   metar : String,
                   year : Int32 = Time.utc_now.year,
                   month : Int32 = Time.utc_now.month,
                   time_interval : Int32 = CrystalMetarParser::Metar::DEFAULT_TIME_INTERVAL)
      return Metar.new(metar, year: year, month: month, time_interval: time_interval)
    end
  end
end
