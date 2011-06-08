# Babosa

Babosa is a library for creating human-friendly identifiers. Its primary
intended purpose is for creating URL slugs, but can also be useful for
normalizing and sanitizing data.

It is an extraction and improvement of the string code from
[FriendlyId](http://github.com/norman/friendly_id). I have released this as a
separate library to help developers who want to create libraries similar to
FriendlyId.

## Features / Usage

### ASCII transliteration

    "Gölcük, Turkey".to_slug.transliterate.to_s #=> "Golcuk, Turkey"

### Per-locale transliteration

    "Jürgen Müller".to_slug.transliterate.to_s           #=> "Jurgen Muller"
    "Jürgen Müller".to_slug.transliterate(:german).to_s  #=> "Juergen Mueller"

Many European languages using both Roman and Cyrillic alphabets are supported.
I'll gladly accept contributions from fluent speakers to support more
languages.

### Non-ASCII removal

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

Babosa can also generate strings for Ruby method names. (Yes, Ruby 1.9 can use UTF-8 chars
in method names, but you may not want to):


    "this is a method".to_slug.to_ruby_method! #=> this_is_a_method
    "über cool stuff!".to_slug.to_ruby_method! #=> uber_cool_stuff!

    # You can also disallow trailing punctuation chars
    "über cool stuff!".to_slug.to_ruby_method(false) #=> uber_cool_stuff


You can easily add custom transliterators for your language with very little code,
for example here's the transliterator for German:

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


### UTF-8 support

Babosa has no hard dependencies, but if you have either the Unicode or
ActiveSupport gems installed and required prior to requiring "babosa", these
will be used to perform upcasing and downcasing on UTF-8 strings. On JRuby 1.5
and above, Java's native Unicode support will be used instead. Unless you're on
JRuby, which already has excellent support for Unicode via Java's Standard
Library, I recommend using the Unicode gem because it's the fastest Ruby Unicode
library available.

If none of these libraries are available, Babosa falls back to a simple module
which **only** supports Latin characters.

This default module is fast and can do very naive Unicode composition to ensure
that, for example, "é" will always be composed to a single codepoint rather than
an "e" and a "´" - making it safe to use as a hash key. But seriously - save
yourself the headache and install a real Unicode library.

If you are using Babosa with a language that uses the Cyrillic alphabet, Babosa
requires either Unicode, Active Support or Java.


### Rails 3

Some of Babosa's functionality is already present in Active Support/Rails 3.

Babosa differs from ActiveSupport primarily in that it supports non-Latin
strings by default, and has per-locale ASCII transliterations already baked-in.
If you are considering using Babosa with Rails 3, you should first take a look
at Active Support's
[transliterate](http://edgeapi.rubyonrails.org/classes/ActiveSupport/Inflector.html#M000565)
and
[parameterize](http://edgeapi.rubyonrails.org/classes/ActiveSupport/Inflector.html#M000566)
because it may already do what you need.

### More info

Please see the [API docs](http://norman.github.com/babosa) and source code for more info.

## Getting it

Babosa can be installed via Rubygems:

    gem install babosa

You can get the source code from its [Github repository](http://github.com/norman/babosa).

Babosa is tested to be compatible with Ruby 1.8.6-1.9.2, JRuby 1.4-1.5, and
Rubinius 1.0.x. It's probably compatible with other Rubies as well.

## Reporting bugs

Please use Babosa's [Github issue tracker](http://github.com/norman/babosa/issues).


## Misc

"Babosa" means slug in Spanish.

## Author

[Norman Clarke](http://njclarke.com)

## Contributors

* [Tiberiu C. Turbureanu](https://gitorious.org/~tct) - Romanian support
* [Kim Joar Bekkelund](https://github.com/kjbekkelund) - Norwegian support
* [Alexey Shkolnikov](https://github.com/grlm) - Russian support
* [Martin Petrov](https://github.com/martin-petrov) - Bulgarian support
* [Molte Emil Strange Andersen](https://github.com/molte) - Danish support
* [Milan Dobrota](https://github.com/milandobrota) - Serbian support


## Changelog

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

Copyright (c) 2010-2011 Norman Clarke

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
