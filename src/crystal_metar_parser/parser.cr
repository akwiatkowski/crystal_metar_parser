module CrystalMetarParser
  class Parser
    def self.parse(metar, year = nil, month = nil, time_interval = nil)
      return Metar.new(metar, year: year, month: month, time_interval: time_interval)
    end
  end
end
