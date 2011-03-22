# encoding: utf-8

require 'singleton'

module Babosa

  STRIPPABLE = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 33, 34, 35, 36, 37, 38, 39,
    40, 41, 42, 43, 44, 45, 46, 47, 58, 59, 60, 61, 62, 63, 64, 91, 92, 93, 94,
    95, 96, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136,
    137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151,
    152, 153, 154, 155, 156, 157, 158, 159, 161, 162, 163, 164, 165, 166, 167,
    168, 169, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 182, 183, 184,
    185, 187, 188, 189, 190, 191, 215, 247]


  module Transliterator

    autoload :Latin,   "babosa/transliterator/latin"
    autoload :Spanish, "babosa/transliterator/spanish"
    autoload :German,  "babosa/transliterator/german"
    autoload :Danish,  "babosa/transliterator/danish"
    autoload :Serbian, "babosa/transliterator/serbian"

    def self.get(symbol)
      klass = symbol.to_s.split("_").map {|a| a.gsub(/\b('?[a-z])/) { $1.upcase }}.join
      const_get(klass).instance
    end

    class Base

      include Singleton

      APPROXIMATIONS = {
        "×" => "x",
        "÷" => "/",
        "‘" => "'",
        "‛" => "'",
        "―" => "-",
        "‐" => "-",
        "‑" => "-",
        "‒" => "-",
        "–" => "-",
        "—" => "-",
        "“" => '"',
        "”" => '"',
        "„" => '"',
        "‟" => '"',
        '’' => "'"
      }

      attr_reader :approximations

      def initialize
        if self.class < Base
          @approximations = self.class.superclass.instance.approximations.dup
        else
          @approximations = {}
        end
        self.class.const_get(:APPROXIMATIONS).inject(@approximations) do |memo, object|
          index       = object[0].unpack("U").shift
          value       = object[1].unpack("C*")
          memo[index] = value.length == 1 ? value[0] : value
          memo
        end
      end

      # Accepts a single UTF-8 codepoint and returns the ASCII character code used
      # as the transliteration value.
      def [](codepoint)
        @approximations[codepoint]
      end
    end
  end
end
