require "./spec_helper"

describe CrystalMetarParser do
  it "works" do
    metar = CrystalMetarParser::Parser.parse("EPPO 191200Z 29005KT 9999 FEW011 BKN021 09/06 Q1019")

    metar.visibility.visibility.should eq CrystalMetarParser::Visibility::MAX_VISIBILITY
    metar.city.code.should eq "EPPO"
    metar.wind.speed.should be > 2.50
    metar.wind.speed.should be < 2.60

    puts metar.wind.speed_kmh
  end
end
