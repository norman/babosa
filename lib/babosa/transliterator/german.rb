# frozen_string_literal: true

module Babosa
  module Transliterator
    class German < Latin
      APPROXIMATIONS = {
        "ä" => "ae",
        "ö" => "oe",
        "ü" => "ue",
        "Ä" => "Ae",
        "Ö" => "Oe",
        "Ü" => "Ue"
      }.freeze
    end
  end
end
