require "./spec_helper"

describe CrystalMetarParser do
  it "works" do
    metar = CrystalMetarParser::Parser.parse("EPPO 191200Z 29005KT 9999 FEW011 BKN021 09/06 Q1019")

    metar.visibility.visibility.should eq CrystalMetarParser::Visibility::MAX_VISIBILITY
    metar.city.code.should eq "EPPO"
    metar.wind.speed.should be > 2.50
    metar.wind.speed.should be < 2.60
    metar.temperature.degrees.should eq 9
    metar.temperature.dew.should eq 6
    metar.pressure.pressure.should eq 1019
    metar.time.time.day.should eq 19
    metar.time.time.hour.should eq 12
    metar.specials.specials.size.should eq 0
    metar.runway.runways.size.should eq 0
    metar.clouds.clouds.size.should eq 2

    # puts metar.to_hash.inspect
  end

  it "works with custom year and month" do
    metar = CrystalMetarParser::Parser.parse("EPPO 191200Z 29005KT 9999 FEW011 BKN021 09/06 Q1019", year: 2020, month: 1, time_interval: 60*60)

    metar.time.time.year.should eq 2020
    metar.time.time.month.should eq 1
    (metar.time.time_to - metar.time.time_from).to_i.should eq 60 * 60
  end
end
