module CrystalMetarParser
  class Parser
    def self.parse(metar, options = {} of String => String)
      return Metar.new(metar, options)
    end
  end
end
