# encoding: utf-8
module Babosa
  module Transliterator
    class Hindi < Base
      APPROXIMATIONS = {
        "ऀ" => "n",
        "ँ" => "n",
        "ं" => "n",
        "ः" => "h",
        "ऄ" => "a",
        "अ" => "a",
        "आ" => "aa",
        "इ" => "i",
        "ई" => "ii",
        "उ" => "u",
        "ऊ" => "uu",
        "ऋ" => "ri",
        "ऌ" => "lri",
        "ऍ" => "e",
        "ऎ" => "e",
        "ए" => "e",
        "ऐ" => "ei",
        "ऑ" => "o",
        "ऒ" => "o",
        "ओ" => "o",
        "औ" => "ou",
        "क" => "k",
        "ख" => "kh",
        "ग" => "g",
        "घ" => "gh",
        "ङ" => "d",
        "च" => "ch",
        "छ" => "chh",
        "ज" => "j",
        "झ" => "jh",
        "ञ" => "ny",
        "ट" => "tt",
        "ड" => "dd",
        "ढ" => "ddh",
        "ण" => "nn",
        "त" => "t",
        "थ" => "th",
        "द" => "d",
        "ध" => "dh",
        "न" => "n",
        "ऩ" => "nnn",
        "प" => "p",
        "फ" => "ph",
        "ब" => "b",
        "भ" => "bh",
        "म" => "m",
        "य" => "y",
        "र" => "r",
        "ऱ" => "rr",
        "ल" => "l",
        "ळ" => "ll",
        "ऴ" => "ll",
        "व" => "v",
        "श" => "sh",
        "ष" => "ss",
        "स" => "s",
        "ह" => "h",
        "ऺ" => "oe",
        "ऻ" => "ooe",
        "़" => "",
        "ऽ" => "-",
        "ा" => "aa",
        "ि" => "i",
        "ी" => "ii",
        "ु" => "u",
        "ू" => "uu",
        "ृ" => "r",
        "ॄ" => "rr",
        "ॅ" => "e",
        "ॆ" => "e",
        "े" => "e",
        "ै" => "ai",
        "ॉ" => "o",
        "ॊ" => "o",
        "ो" => "o",
        "ौ" => "au",
        "्" => "",
        "ॎ" => "e",
        "ॏ" => "aw",
        "ॐ" => "om",
        "॑" => "",
        "॒" => "_",
        "॓" => "",
        "॔" => "",
        "ॕ" => "ee",
        "ॖ" => "ue",
        "ॗ" => "uue",
        "क़" => "q",
        "ख़" => "khh",
        "ग़" => "ghh",
        "ज़" => "za",
        "ड़" => "dddh",
        "ढ़" => "rh",
        "फ़" => "f",
        "य़" => "yy",
        "ॡ" => "lr",
        "ॢ" => "l",
        "ॣ" => "l",
        "।" => ".",
        "॥" => "..",
        "०" => "0",
        "१" => "1",
        "२" => "2",
        "३" => "3",
        "४" => "4",
        "५" => "5",
        "६" => "6",
        "७" => "7",
        "८" => "8",
        "९" => "9",
        "॰" => ".",
        "ॱ" => ".",
        "ॲ" => "a",
        "ॳ" => "oe",
        "ॴ" => "ooe",
        "ॵ" => "aw",
        "ॶ" => "ue",
        "ॷ" => "uue",
        "ॸ" => "dd",
        "ॹ" => "zh",
        "ॺ" => "y",
        "ॻ" => "gg",
        "ॼ" => "jj",
        "ॽ" => "?",
        "ॾ" => "ddd",
        "ॿ" => "bb"
      }
    end
  end
end
