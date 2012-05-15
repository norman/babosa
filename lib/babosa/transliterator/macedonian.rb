# encoding: utf-8
module Babosa
  module Transliterator
    class Macedonian < Cyrillic
      APPROXIMATIONS = {
        "Ѓ" => "Gj",
        "Љ" => "Lj",
        "Њ" => "Nj",
        "Ќ" => "Kj",
        "Џ" => "Dzh",
        "Ж" => "Zh",
        "Ц" => "C",
        "S" => "Z",
        "ѓ" => "gj",
        "љ" => "lj",
        "њ" => "nj",
        "ќ" => "kj",
        "џ" => "dzh",
        "ж" => "zh",
        "ц" => "c",
        "s" => "z",
      }
    end
  end
end
