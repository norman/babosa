# frozen_string_literal: true

require "singleton"

module Babosa
  module Transliterator
    def self.get(symbol)
      class_name = symbol.to_s.split("_").map { |a| a.gsub(/\b('?[a-z])/) { Regexp.last_match(1).upcase } }.join
      const_get(class_name)
    end

    class Base
      include Singleton

      APPROXIMATIONS = {
        "×" => "x",
        "÷" => "/",
        "‐" => "-",
        "‑" => "-",
        "‒" => "-",
        "–" => "-",
        "—" => "-",
        "―" => "-",
        "‘" => "'",
        "‛" => "'",
        "“" => '"',
        "”" => '"',
        "„" => '"',
        "‟" => '"',
        "’" => "'",
        "，" => ",",
        "。" => ".",
        "！" => "!",
        "？" => "?",
        "、" => ",",
        "（" => "(",
        "）" => ")",
        "【" => "[",
        "】" => "]",
        "；" => ";",
        "：" => ":",
        "《" => "<",
        "》" => ">",
        # various kinds of space characters
        "\xc2\xa0" => " ",
        "\xe2\x80\x80" => " ",
        "\xe2\x80\x81" => " ",
        "\xe2\x80\x82" => " ",
        "\xe2\x80\x83" => " ",
        "\xe2\x80\x84" => " ",
        "\xe2\x80\x85" => " ",
        "\xe2\x80\x86" => " ",
        "\xe2\x80\x87" => " ",
        "\xe2\x80\x88" => " ",
        "\xe2\x80\x89" => " ",
        "\xe2\x80\x8a" => " ",
        "\xe2\x81\x9f" => " ",
        "\xe3\x80\x80" => " "
      }.freeze

      attr_reader :approximations

      def initialize
        @approximations = if self.class < Base
          self.class.superclass.instance.approximations.dup
        else
          {}
        end
        self.class.const_get(:APPROXIMATIONS).each_with_object(@approximations) do |object, memo|
          index = object[0].codepoints.shift
          value = object[1].codepoints
          memo[index] = value.length == 1 ? value[0] : value
        end
        @approximations.freeze
      end

      # Accepts a single UTF-8 codepoint and returns the ASCII character code
      # used as the transliteration value.
      def [](codepoint)
        @approximations[codepoint]
      end

      # Transliterates a string.
      def transliterate(string)
        string.codepoints.map { |char| self[char] || char }.flatten.pack("U*")
      end
    end
  end
end

Dir[File.expand_path("*.rb", __dir__)]
  .reject { |f| f.end_with?("base.rb") }
  .sort
  .each(&method(:require))
