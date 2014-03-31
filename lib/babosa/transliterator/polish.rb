# encoding: utf-8
module Babosa
  module Transliterator
    class Polish < Latin
      APPROXIMATIONS = {
        "ą" => "a",
        "ć" => "c",
        "ę" => "e",
        "ł" => "l",
        "ń" => "n",
        "ó" => "o",
        "ś" => "s",
        "ź" => "z",
        "ż" => "z",
        "Ą" => "A",
        "Ć" => "C",
        "Ę" => "E",
        "Ł" => "L",
        "Ń" => "N",
        "Ó" => "O",
        "Ś" => "S",
        "Ź" => "Z",
        "Ż" => "Z"
      }
    end
  end
end
