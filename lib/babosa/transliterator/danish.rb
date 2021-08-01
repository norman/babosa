# frozen_string_literal: true

require_relative "latin"

module Babosa
  module Transliterator
    class Danish < Latin
      APPROXIMATIONS = {
        "æ" => "ae",
        "ø" => "oe",
        "å" => "aa",
        "Ø" => "Oe",
        "Å" => "Aa"
      }.freeze
    end
  end
end
