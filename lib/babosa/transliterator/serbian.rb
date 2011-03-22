# encoding: utf-8

module Babosa
  module Transliterator
    class Serbian < Latin
      APPROXIMATIONS = {"Ð" => "Dj", "đ" => "dj" ,"Č" => "Ch", "č" => "ch", "Š" => "Sh", "š" => "sh"}
    end
  end
end
