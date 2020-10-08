# frozen_string_literal: true

module Babosa
  module Transliterator
    class Norwegian < Latin
      APPROXIMATIONS = {
        "ø" => "oe",
        "å" => "aa",
        "Ø" => "Oe",
        "Å" => "Aa"
      }.freeze
    end
  end
end
