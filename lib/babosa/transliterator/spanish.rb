# frozen_string_literal: true

module Babosa
  module Transliterator
    class Spanish < Latin
      APPROXIMATIONS = {"ñ" => "ni", "Ñ" => "Ni"}.freeze
    end
  end
end
