# frozen_string_literal: true

require_relative "latin"

module Babosa
  module Transliterator
    class Romanian < Latin
      APPROXIMATIONS = {
        "ș" => "s",
        "ț" => "t",
        "Ș" => "S",
        "Ț" => "T"
      }.freeze
    end
  end
end
