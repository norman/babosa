# frozen_string_literal: true

require_relative "cyrillic"

module Babosa
  module Transliterator
    class Ukrainian < Cyrillic
      APPROXIMATIONS = {
        "Г" => "H",
        "г" => "h",
        "Ґ" => "G",
        "ґ" => "g",
        "є" => "ie",
        "И" => "Y",
        "и" => "y",
        "І" => "I",
        "і" => "i",
        "ї" => "i",
        "Й" => "Y",
        "й" => "i",
        "Х" => "Kh",
        "х" => "kh",
        "Ц" => "Ts",
        "ц" => "ts",
        "Щ" => "Shch",
        "щ" => "shch",
        "ю" => "iu",
        "я" => "ia",
        "'" => ""
      }.freeze
    end
  end
end
