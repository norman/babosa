module Babosa
  module Transliterator
    class Romanian < Latin
      APPROXIMATIONS = {
        "ș" => "s",
        "ț" => "t",
        "Ș" => "S",
        "Ț" => "T"
      }
    end
  end
end
