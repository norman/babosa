# encoding: utf-8
module Babosa
  module Transliterator
    class Turkish < Latin
      APPROXIMATIONS = {
      	"Ç" => "Ç",
      	"Ğ" => "Ğ",
      	"İ" => "İ",
      	"Ö" => "Ö",
      	"Ş" => "Ş",
      	"Ü" => "Ü",
   			"ç" => "ç",
   			"ğ" => "ğ",
      	"ı" => "ı",
      	"ö" => "ö",
      	"ş" => "ş",
      	"ü" => "ü"
      }
    end
  end
end
