# frozen_string_literal: true

require_relative "latin"

module Babosa
  module Transliterator
    class Swedish < Latin
      APPROXIMATIONS = {
        "å" => "aa",
        "ä" => "ae",
        "ö" => "oe",
        "Å" => "Aa",
        "Ä" => "Ae",
        "Ö" => "Oe"
      }.freeze
    end
  end
end
