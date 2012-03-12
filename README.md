# Babosa

Babosa is a library for creating human-friendly identifiers, aka "slugs". It can
also be useful for normalizing and sanitizing data.

It is an extraction and improvement of the string code from
[FriendlyId](http://github.com/norman/friendly_id). I have released this as a
separate library to help developers who want to create libraries similar to
FriendlyId.

## Features / Usage

### Transliterate UTF-8 characters to ASCII

    "Gölcük, Turkey".to_slug.transliterate.to_s #=> "Golcuk, Turkey"

### Locale sensitive transliteration, with support for many languages

    "Jürgen Müller".to_slug.transliterate.to_s           #=> "Jurgen Muller"
    "Jürgen Müller".to_slug.transliterate(:german).to_s  #=> "Juergen Mueller"

Currently supported languages include:

* Bulgarian
* Danish
* German
* Greek
* Macedonian
* Norwegian
* Romanian
* Russian
* Serbian
* Spanish
* Swedish
* Ukrainian


I'll gladly accept contributions from fluent speakers to support more languages.

### Strip non-ASCII characters

    "Gölcük, Turkey".to_slug.to_ascii.to_s #=> "Glck, Turkey"

### Truncate by characters

    "üüü".to_slug.truncate(2).to_s #=> "üü"

### Truncate by bytes

This can be useful to ensure the generated slug will fit in a database column
whose length is limited by bytes rather than UTF-8 characters.

    "üüü".to_slug.truncate_bytes(2).to_s #=> "ü"

### Remove punctuation chars

    "this is, um, **really** cool, huh?".to_slug.word_chars.to_s #=> "this is um really cool huh"

### All-in-one

    "Gölcük, Turkey".to_slug.normalize.to_s #=> "golcuk-turkey"

### Other stuff

#### Using Babosa With FriendlyId 4

    require "babosa"

    class Person < ActiveRecord::Base
      friendly_id :name, use: :slugged

      def normalize_friendly_id(input)
        input.to_s.to_slug.normalize(transliterations: :russian).to_s
      end
    end

#### Pedantic UTF-8 support

Babosa goes out of its way to handle [nasty Unicode issues you might never think
you would have](https://github.com/norman/enc/blob/master/equivalence.rb) by
checking, sanitizing and normalizing your string input.

It will automatically use whatever Unicode library you have loaded before
Babosa, or fall back to a simple built-in library. Supported
Unicode libraries include:

* Java (only JRuby of course)
* Active Support
* [Unicode](https://github.com/blackwinter/unicode)
* Built-in

This built-in module is much faster than Active Support but much slower than
Java or Unicode. It can only do **very** naive Unicode composition to ensure
that, for example, "é" will always be composed to a single codepoint rather than
an "e" and a "´" - making it safe to use as a hash key.

But seriously - save yourself the headache and install a real Unicode library.
If you are using Babosa with a language that uses the Cyrillic alphabet, Babosa
requires either Unicode, Active Support or Java.

#### Ruby Method Names

Babosa can also generate strings for Ruby method names. (Yes, Ruby 1.9 can use
UTF-8 chars in method names, but you may not want to):


    "this is a method".to_slug.to_ruby_method! #=> this_is_a_method
    "über cool stuff!".to_slug.to_ruby_method! #=> uber_cool_stuff!

    # You can also disallow trailing punctuation chars
    "über cool stuff!".to_slug.to_ruby_method(false) #=> uber_cool_stuff

#### Easy to Extend

You can add custom transliterators for your language with very little code. For
example here's the transliterator for German:

    # encoding: utf-8
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
          }
        end
      end
    end

And a spec (you can use this as a template):

    # encoding: utf-8
    require File.expand_path("../../spec_helper", __FILE__)

    describe Babosa::Transliterator::German do

      let(:t) { described_class.instance }
      it_behaves_like "a latin transliterator"

      it "should transliterate Eszett" do
        t.transliterate("ß").should eql("ss")
      end

      it "should transliterate vowels with umlauts" do
        t.transliterate("üöä").should eql("ueoeae")
      end

    end


### Rails 3

Some of Babosa's functionality was added to Active Support 3.

Babosa now differs from ActiveSupport primarily in that it supports non-Latin
strings by default, and has per-locale ASCII transliterations already baked-in.
If you are considering using Babosa with Rails 3, you may want to first take a
look at Active Support's
[transliterate](http://edgeapi.rubyonrails.org/classes/ActiveSupport/Inflector.html#M000565)
and
[parameterize](http://edgeapi.rubyonrails.org/classes/ActiveSupport/Inflector.html#M000566)
to see if they suit your needs.

### Babosa vs. Stringex

Babosa provides much of the functionality provided by the
[Stringex](https://github.com/rsl/stringex) gem, but in the subjective opinion
of the author, is for most use cases a much better choice.

#### Fewer Features

Stringex offers functionality for storing slugs in an Active Record model, like
a simple version of [FriendlyId](http://github.com/norman/friendly_id), in
addition to string processing. Babosa only does string processing.

#### Less Aggressive Unicode Transliteration

Stringex uses an agressive Unicode to ASCII mapping which outputs gibberish for
almost anything but Western European langages. Babosa supports only languages
for which fluent speakers have provided transliterations, to ensure that the
output makes sense to users.

#### Better Locale Support

Recent versions of Stringex support locale-specific transliterations, but
include no built-in support for any languages. Babosa works out of the box for
most European languages and is easy to extend if your language is not supported.

#### Unicode Support

Stringex does no Unicode normalization or validation before transliterating
strings, so if you pass in strings with encoding errors or with different
Unicode normalizations, you'll get unpredictable results.

#### No Locale Assumptions

Babosa avoids making assumptions about locales like Stringex does, so it doesn't
offer transliterations like this out of the box:

    "$12 worth of Ruby power".to_url => "12-dollars-worth-of-ruby-power"

This is because the symbol "$" is used by many Latin American countries for the
peso. Stringex does this in many places, for example, transliterating all Han
characters into Pinyin, effectively treating Japanese text as if it were
Chinese.


### More info

Please see the [API docs](http://norman.github.com/babosa) and source code for
more info.

## Getting it

Babosa can be installed via Rubygems:

    gem install babosa

You can get the source code from its [Github repository](http://github.com/norman/babosa).

Babosa is tested to be compatible with Ruby 1.8.6-1.9.2, JRuby 1.4+, and
Rubinius 1.0+ It's probably compatible with other Rubies as well.

## Reporting bugs

Please use Babosa's [Github issue
tracker](http://github.com/norman/babosa/issues).


## Misc

"Babosa" means slug in Spanish.

## Author

[Norman Clarke](http://njclarke.com)

## Contributors

Many thanks to the following people for their help:

* [Philip Arndt](https://github.com/parndt) - Bugfixes
* [Jonas Forsberg](https://github.com/himynameisjonas) - Swedish support
* [Jaroslav Kalistsuk](https://github.com/jarosan) - Greek support
* [Steven Heidel](https://github.com/stevenheidel) - Bugfixes
* [Edgars Beigarts](https://github.com/ebeigarts) - Support for multiple transliterators
* [Tiberiu C. Turbureanu](https://gitorious.org/~tct) - Romanian support
* [Kim Joar Bekkelund](https://github.com/kjbekkelund) - Norwegian support
* [Alexey Shkolnikov](https://github.com/grlm) - Russian support
* [Martin Petrov](https://github.com/martin-petrov) - Bulgarian support
* [Molte Emil Strange Andersen](https://github.com/molte) - Danish support
* [Milan Dobrota](https://github.com/milandobrota) - Serbian support


## Changelog

* 0.3.7 - Fix compatibility with Ruby 1.8.7. Add Swedish support.
* 0.3.6 - Allow multiple transliterators. Add Greek support.
* 0.3.5 - Don't strip underscores from identifiers.
* 0.3.4 - Add Romanian support.
* 0.3.3 - Add Norwegian support.
* 0.3.2 - Improve Macedonian support.
* 0.3.1 - Small fixes to Cyrillic.
* 0.3.0 - Cyrillic support. Improve support for various Unicode spaces and dashes.
* 0.2.2 - Fix for "smart" quote handling.
* 0.2.1 - Implement #empty? for compatiblity with Active Support's #blank?.
* 0.2.0 - Added support for Danish. Added method to generate Ruby identifiers. Improved performance.
* 0.1.1 - Added support for Serbian.
* 0.1.0 - Initial extraction from FriendlyId.

## Copyright

Copyright (c) 2010-2012 Norman Clarke

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
