# encoding: utf-8
module Babosa
  module Transliterator
    class Ukranian < Cyrillic
      APPROXIMATIONS = {
        "И" => "Y",
        "и" => "y",
      }
    end
  end
end