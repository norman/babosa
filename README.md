# Babosa

Babosa is a library for creating slugs. It is an extraction and improvement of
the string code from [FriendlyId](http://github.com/norman/friendly_id),
intended to help developers create libraries similar to FriendlyId.

## Features / Usage

### ASCII transliteration

    "Gölcük, Turkey".to_slug.approximate_ascii.to_s #=> "Golcuk, Turkey"

### Special cases for German and Spanish

    "Jürgen Müller".to_slug.approximate_ascii.to_s           #=> "Jurgen Muller"
    "Jürgen Müller".to_slug.approximate_ascii(:german).to_s  #=> "Juergen Mueller"
    "feliz año".to_slug.approximate_ascii.to_s               #=> "feliz ano"
    "feliz año".to_slug.approximate_ascii(:spanish).to_s     #=> "feliz anio"

### Non-ASCII removal

    "Gölcük, Turkey".to_slug.to_ascii.to_s #=> "Glck, Turkey"

### Truncate by characters

    "üüü".to_slug.truncate(2).to_s #=> "üü"

### Truncate by bytes

This can be useful to ensure the generated slug will fit in a database column
whose length is limited by bytes rather than UTF-8 characters.

    "üüü".to_slug.truncate_bytes(2).to_s #=> "ü"

### All-in-one

    "Gölcük, Turkey".to_slug.normalize.to_s #=> "golcuk-turkey"

There are many more features; check the API docs and source code to find out
more.

## Getting it

Babosa can be installed via Rubygems:

    gem install babosa

You can get the source code from its [Github repository](http://github.com/norman/babosa).

## Reporting bugs

Please use Babosa's [Github issue tracker](http://github.com/norman/babosa/issues).


## Misc

The speed and quality of Babosa's UTF-8 support depends on which Ruby and which
gems you are using.

On JRuby 1.5 and above, Babosa uses Java's native UTF-8 support. If you require
[Unicode](http://github.com/blackwinter/unicode) or ActiveSupport before
Babosa, it will use the support provided by those libraries. Otherwise, Babosa
defaults to very basic UTF-8 support for Latin characters only.

"Babosa" means slug in Spanish.

## Author

[Norman Clarke](http://njclarke.com)

## Slugs

Here's a video of a slug that has absolutely no reason for being here. Is that
Throbbing Gristle playing in the background?

<object width="480" height="385"><param name="movie" value="http://www.youtube.com/v/TCFavfrUVjQ&amp;hl=en_US&amp;fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/TCFavfrUVjQ&amp;hl=en_US&amp;fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed></object>

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
