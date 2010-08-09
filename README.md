# Babosa

Babosa is a library for creating slugs. It is an extraction and improvement of
the string code from [FriendlyId](http://github.com/norman/friendly_id),
intended to help developers create similar libraries and plugins.

## Features / Usage

### ASCII transliteration

    "Gölcük, Turkey".to_slug.approximate_ascii.to_s #=> "Golcuk, Turkey"

### Per-locale transliteration

    "Jürgen Müller".to_slug.approximate_ascii.to_s           #=> "Jurgen Muller"
    "Jürgen Müller".to_slug.approximate_ascii(:german).to_s  #=> "Juergen Mueller"

Currently, only German, Spanish and Serbian are supported. I'll gladly accept
contributions and support more languages.

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


### UTF-8 support

Babosa has no hard dependencies, but if you have either the Unicode or
ActiveSupport gems installed and required prior to requiring "babosa", these
will be used to perform upcasing and downcasing on UTF-8 strings. On JRuby 1.5
and above, Java's native Unicode support will be used.

If none of these libraries are available, Babosa falls back to a simple module
which supports only Unicode strings only with Latin characters. I recommend
using the Unicode gem where possible since it's a C extension and is very fast.


### Rails 3

Most of Babosa's functionality is already present in Active Support/Rails 3.
Babosa exists primarily to support non-Rails applications, and Rails apps prior
to 3.0. Most of the code here was originally written for FriendlyId. Several
things, like tidy_bytes and ASCII transliteration, were later added to Rails and I18N.

Babosa differs from ActiveSupport primarily in that it supports non-Latin
strings by default. If you are considering using Babosa with Rails 3, you should first
take a look at Active Support's
[transliterate](http://edgeapi.rubyonrails.org/classes/ActiveSupport/Inflector.html#M000565)
and
[parameterize](http://edgeapi.rubyonrails.org/classes/ActiveSupport/Inflector.html#M000566)
because it's very likely they already do what you need.

### More info

Please see the [API docs](http://norman.github.com/babosa) and source code for more info.

## Getting it

Babosa can be installed via Rubygems:

    gem install babosa

You can get the source code from its [Github repository](http://github.com/norman/babosa).

Babosa is tested to be compatible with Ruby 1.8.6-1.9.2, JRuby 1.4-1.5,
Rubinius 1.0, and is probably compatible with other Rubies as well.

## Reporting bugs

Please use Babosa's [Github issue tracker](http://github.com/norman/babosa/issues).


## Misc

"Babosa" means slug in Spanish.

## Author

[Norman Clarke](http://njclarke.com)

## Contributors

* [Milan Dobrota](http://github.com/milandobrota) - Serbian support


## Changelog

* 0.1.1 - Added support for Serbian.
* 0.1.0 - Initial extraction from FriendlyId.

## Copyright

Copyright (c) 2010 Norman Clarke

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
