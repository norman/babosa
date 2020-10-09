# Babosa Changelog

## 2.0.0

This release contains no important changes. I had a week off from work and
decided to refactor the code.  However there are some small breaking changes so
I have released it as 2.0.0.

* Refactor internals for simplicity
* Use built-in Ruby UTF-8 support in places of other gems.
* Drop support for Ruby < 2.5.0.
* `Babosa::Identifier#word_chars` no longer removes dashes
* `Babosa::Identifier#to_ruby_method` default argument `allow_bangs` is now a keyword argument

## 1.0.4

* Fix nil being cast to frozen string (https://github.com/norman/babosa/pull/52)

## 1.0.3

* Fix Active Support 6 deprecations (https://github.com/norman/babosa/pull/50)

## 1.0.2

* Fix regression in ActiveSupport UTF8 proxy.

## 1.0.1

* Fix error with tidy_bytes on Rubinius.
* Simplify Active Support UTF8 proxy.
* Fix `allow_bangs` argument to to_ruby_method being silently ignored.
* Raise error when generating an impossible Ruby method name.

## 1.0.0

* Adopt semantic versioning.
* When using Active Support, require 3.2 or greater.
* Require Ruby 2.0 or greater.
* Fix Ruby warnings.
* Improve support for Ukrainian.
* Support some additional punctuation characters used by Chinese and others.
* Add Polish spec.
* Use native Unicode normalization on Ruby 2.2 in UTF8::DumbProxy.
* Invoke Ruby-native upcase/downcase in UTF8::DumbProxy.
* Proxy `tidy_bytes` method to Active Support when possible.
* Remove SlugString constant.

## 0.3.11

*  Add support for Vietnamese.

## 0.3.10

*  Fix Macedonian "S/S". Don't `include JRuby` unnecessarily.

## 0.3.9

* Add missing Greek vowels with diaeresis.

## 0.3.8

* Correct and improve Macedonian support.

## 0.3.7

* Fix compatibility with Ruby 1.8.7.
* Add Swedish support.

## 0.3.6

* Allow multiple transliterators.
* Add Greek support.

## 0.3.5

* Don't strip underscores from identifiers.

## 0.3.4

* Add Romanian support.

## 0.3.3

* Add Norwegian support.

## 0.3.2

* Improve Macedonian support.

## 0.3.1

* Small fixes to Cyrillic.

## 0.3.0

* Cyrillic support.
* Improve support for various Unicode spaces and dashes.

## 0.2.2

* Fix for "smart" quote handling.

## 0.2.1

* Implement #empty? for compatiblity with Active Support's #blank?.

## 0.2.0

* Add support for Danish.
* Add method to generate Ruby identifiers.
* Improve performance.

## 0.1.1

* Add support for Serbian.

## 0.1.0

* Initial extraction from FriendlyId.
