[wiki-metar]: https://en.wikipedia.org/wiki/METAR

# crystal_metar_parser

Process [METAR][wiki-metar] information.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  crystal_metar_parser:
    github: akwiatkowski/crystal_metar_parser
```


## Usage


```crystal
require "crystal_metar_parser"

metar = CrystalMetarParser::Parser.parse("EPPO 191200Z 29005KT 9999 FEW011 BKN021 09/06 Q1019")

puts metar.temperature.degrees

```


## Contributing

1. Fork it ( https://github.com/akwiatkowski/crystal_metar_parser/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- akwiatkowski(https://github.com/akwiatkowski) Aleksander Kwiatkowski - creator, maintainer
