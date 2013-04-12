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
        "Ѕ" => "Z",
        "Ј" => "J",
        "ѓ" => "gj",
        "љ" => "lj",
        "њ" => "nj",
        "ќ" => "kj",
        "џ" => "dzh",
        "ж" => "zh",
        "ц" => "c",
        "ѕ" => "z",
        "ј" => "j"
      }
    end
  end
end
