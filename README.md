# Babosa

[![Build Status](https://github.com/norman/babosa/actions/workflows/main.yml/badge.svg)](https://github.com/norman/babosa/actions)

Babosa is a library for creating human-friendly identifiers, aka "slugs". It can
also be useful for normalizing and sanitizing data.

It is an extraction and improvement of the string code from
[FriendlyId](http://github.com/norman/friendly_id). I have released this as a
separate library to help developers who want to create libraries similar to
FriendlyId.

## Features / Usage

### Transliterate UTF-8 characters to ASCII

```ruby
"Gölcük, Turkey".to_slug.transliterate.to_s #=> "Golcuk, Turkey"
```

### Locale sensitive transliteration, with support for many languages

```ruby
"Jürgen Müller".to_slug.transliterate.to_s           #=> "Jurgen Muller"
"Jürgen Müller".to_slug.transliterate(:german).to_s  #=> "Juergen Mueller"
```

Currently supported languages include:

* Bulgarian
* Danish
* German
* Greek
* Hindi
* Macedonian
* Norwegian
* Romanian
* Russian
* Serbian
* Spanish
* Swedish
* Turkish
* Ukrainian
* Vietnamese

Additionally there are generic transliterators for transliterating from the
Cyrillic alphabet and Latin alphabet with diacritics. The Latin transliterator
can be used, for example, with Czech. There is also a transliterator named
"Hindi" which may be sufficient for other Indic languages using Devanagari, but
I do not know enough to say whether the transliterations would make sense.

I'll gladly accept contributions from fluent speakers to support more languages.

### Strip non-ASCII characters

```ruby
"Gölcük, Turkey".to_slug.to_ascii.to_s #=> "Glck, Turkey"
```

### Truncate by characters

```ruby
"üüü".to_slug.truncate(2).to_s #=> "üü"
```

### Truncate by bytes

This can be useful to ensure the generated slug will fit in a database column
whose length is limited by bytes rather than UTF-8 characters.

```ruby
"üüü".to_slug.truncate_bytes(2).to_s #=> "ü"
```

### Remove punctuation chars

```ruby
"this is, um, **really** cool, huh?".to_slug.word_chars.to_s #=> "this is um really cool huh"
```

### All-in-one

```ruby
"Gölcük, Turkey".to_slug.normalize.to_s #=> "golcuk-turkey"
```

### Other stuff

#### Using Babosa With FriendlyId 4+

```ruby
require "babosa"

class Person < ActiveRecord::Base
  friendly_id :name, use: :slugged

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end
end
```

#### UTF-8 support

Babosa normalizes all input strings [to NFC](https://en.wikipedia.org/wiki/Unicode_equivalence#Normal_forms).

#### Ruby Method Names

Babosa can generate strings for Ruby method names. (Yes, Ruby 1.9+ can use
UTF-8 chars in method names, but you may not want to):


```ruby
"this is a method".to_slug.to_ruby_method! #=> this_is_a_method
"über cool stuff!".to_slug.to_ruby_method! #=> uber_cool_stuff!

# You can also disallow trailing punctuation chars
"über cool stuff!".to_slug.to_ruby_method(allow_bangs: false) #=> uber_cool_stuff
```

#### Easy to Extend

You can add custom transliterators for your language with very little code. For
example here's the transliterator for German:

```ruby
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
```

And a spec (you can use this as a template):

```ruby
require "spec_helper"

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
```

### Rails 3.x and higher

Some of Babosa's functionality was added to Active Support 3.0.0.

Babosa now differs from ActiveSupport primarily in that it supports non-Latin
strings by default, and has per-locale ASCII transliterations already baked-in.
If you are considering using Babosa with Rails, you may want to first take a
look at Active Support's
[transliterate](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-transliterate)
and
[parameterize](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-parameterize)
to see if they suit your needs.

Please see the [API docs](http://rubydoc.info/github/norman/babosa/master/frames) and source code for
more info.

## Getting it

Babosa can be installed via Rubygems:

    gem install babosa

You can get the source code from its [Github repository](http://github.com/norman/babosa).

## Reporting bugs

Please use Babosa's [Github issue
tracker](http://github.com/norman/babosa/issues).


## Misc

"Babosa" means "slug" in Spanish.

## Author

[Norman Clarke](http://njclarke.com)

## Contributors

Many thanks to the following people for their help:

* [Dmitry A. Ilyashevich](https://github.com/dmitry-ilyashevich) - Deprecation fixes
* [anhkind](https://github.com/anhkind) - Vietnamese support
* [Martins Zakis](https://github.com/martins) - Bug fixes
* [Vassilis Rodokanakis](https://github.com/vrodokanakis) - Greek support
* [Peco Danajlovski](https://github.com/Vortex) - Macedonian support
* [Philip Arndt](https://github.com/parndt) - Bug fixes
* [Jonas Forsberg](https://github.com/himynameisjonas) - Swedish support
* [Jaroslav Kalistsuk](https://github.com/jarosan) - Greek support
* [Steven Heidel](https://github.com/stevenheidel) - Bug fixes
* [Edgars Beigarts](https://github.com/ebeigarts) - Support for multiple transliterators
* [Tiberiu C. Turbureanu](https://gitorious.org/~tct) - Romanian support
* [Kim Joar Bekkelund](https://github.com/kjbekkelund) - Norwegian support
* [Alexey Shkolnikov](https://github.com/grlm) - Russian support
* [Martin Petrov](https://github.com/martin-petrov) - Bulgarian support
* [Molte Emil Strange Andersen](https://github.com/molte) - Danish support
* [Milan Dobrota](https://github.com/milandobrota) - Serbian support

## Copyright

Copyright (c) 2010-2020 Norman Clarke

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
