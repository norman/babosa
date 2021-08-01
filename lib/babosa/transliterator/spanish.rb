# frozen_string_literal: true

require_relative "latin"

module Babosa
  module Transliterator
    class Spanish < Latin
      APPROXIMATIONS = {"ñ" => "ni", "Ñ" => "Ni"}.freeze
    end
  end
end
