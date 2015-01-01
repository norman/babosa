# encoding: utf-8
module Babosa
  module Transliterator
    class Ukrainian < Cyrillic
      APPROXIMATIONS = {
        "И" => "Y",
        "и" => "y",
        "І" => "I",
        "і" => "i"
      }
    end
  end
end
