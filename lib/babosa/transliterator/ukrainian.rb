# encoding: utf-8
module Babosa
  module Transliterator
    class Ukrainian < Cyrillic
      APPROXIMATIONS = {
        "Г" => "G",
        "г" => "g",
        "Ґ" => "G",
        "ґ" => "g",
        "є" => "ie",
        "И" => "Y",
        "и" => "y",
        "І" => "I",
        "і" => "i",
        "ї" => "i",
        "Й" => "Y",
        "й" => "y",
        "Х" => "Kh",
        "х" => "kh",
        "Ц" => "Ts",
        "ц" => 'ts',
        "Щ" => "Shch",
        "щ" => "shch",
        "ю" => "iu",
        "я" => "ia",
        "'" => ""
      }
    end
  end
end
