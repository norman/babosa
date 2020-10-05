module Babosa
  module Transliterator
    class Danish < Latin
      APPROXIMATIONS = {
        "æ" => "ae",
        "ø" => "oe",
        "å" => "aa",
        "Ø" => "Oe",
        "Å" => "Aa"
      }
    end
  end
end

