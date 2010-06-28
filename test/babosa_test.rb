# encoding: utf-8
$KCODE = 'UTF8' if RUBY_VERSION < '1.9'
$LOAD_PATH << File.expand_path("../../lib", __FILE__)
$LOAD_PATH.uniq!

require "rubygems"
require "bundler"
Bundler.setup
require "test/unit"
require "babosa"

Module.send :include, Module.new {
  def test(name, &block)
    define_method("test_#{name.gsub(/[^a-z0-9_]/i, "_")}".to_sym, &block)
  end
}

module UTF8ProxyTest
  test "should downcase strings" do
    assert_equal "åéîøü", proxy.downcase("ÅÉÎØÜ")
  end

  test "should upcase strings" do
    assert_equal "ÅÉÎØÜ", proxy.upcase("åéîøü")
  end

  test "should compose UTF-8" do
    # ÅÉÎØÜ
    uncomposed_bytes = [65, 204, 138, 69, 204, 129, 73, 204, 130, 195, 152, 85, 204, 136]
    composed_bytes   = [195, 133, 195, 137, 195, 142, 195, 152, 195, 156]
    uncomposed_string = uncomposed_bytes.pack("C*").unpack("U*").pack("U*")
    composed_string   = composed_bytes.pack("C*").unpack("U*").pack("U*")
    assert_equal composed_bytes, proxy.normalize_utf8(uncomposed_string).unpack("C*")
  end
end


if RUBY_ENGINE == "java"
  class JavaProxyTest < Test::Unit::TestCase
    include UTF8ProxyTest
    def proxy
      Babosa::UTF8::JavaProxy
    end
  end
end

class DumbProxyTest < Test::Unit::TestCase
  include UTF8ProxyTest
  def proxy
    Babosa::UTF8::DumbProxy
  end
end

class  BabosaTest < Test::Unit::TestCase

  test "word_chars! should leave only letters and spaces" do
    string = "a*$%^$@!@b$%^&*()*!c"
    assert_match /[a-z ]*/i, string.to_slug.word_chars!
  end

  test "approximate_ascii should transliterate to ascii" do
    slug = (0xC0..0x17E).to_a.pack("U*").to_slug
    output = slug.approximate_ascii
    assert output.length   > slug.length
    assert output.bytesize < slug.bytesize
    assert_match /[\x0-\x7f]*/, output
  end

  test "should lowercase strings" do
    assert_equal "feliz año", "FELIZ AÑO".to_slug.downcase!
  end

  test "should uppercase strings" do
    assert_equal "FELIZ AÑO", "feliz año".to_slug.upcase!
  end

  test "should replace whitespace with dashes" do
    assert_equal "a-b", "a b".to_slug.clean.with_dashes!
  end

  test "should replace multiple spaces with 1 dash" do
    assert_equal "a-b", "a    b".to_slug.clean.with_dashes!
  end

  test "should replace multiple dashes with 1 dash" do
    assert_equal "male-female", "male - female".to_slug.clean.with_dashes!
  end

  test "should strip trailing space" do
    assert_equal "ab", "ab ".to_slug.clean!
  end

  test "should strip leading space" do
    assert_equal "ab", " ab".to_slug.clean!
  end

  test "should strip trailing slashes" do
    assert_equal "ab", "ab-".to_slug.clean!
  end

  test "should strip leading slashes" do
    assert_equal "ab", "-ab".to_slug.clean!
  end

  test "should not modify valid name strings" do
    assert_equal "a-b-c-d", "a-b-c-d".to_slug.clean!
  end

  test "should do special approximations for German" do
    assert_equal "Juergen", "Jürgen".to_slug.approximate_ascii!(:german)
  end

  test "should do special approximations for Spanish" do
    assert_equal "anio", "año".to_slug.approximate_ascii!(:spanish)
  end

  test "should work with non roman chars" do
    assert_equal "検-索", "検 索".to_slug.with_dashes!
  end

  test "should work with invalid UTF-8 strings" do
    %w[approximate_ascii clean downcase word_chars normalize to_ascii upcase with_dashes].each do |method|
      string = "\x93abc".to_slug
      assert_nothing_raised do
        method == "truncate" ? string.send(method, 32) : string.send(method)
      end
    end
  end

  test "should truncate string by byte length" do
    assert_equal "ü",  "üa".to_slug.truncate_bytes!(2)
    assert_equal "",   "üa".to_slug.truncate_bytes!(1)
    assert_equal "üa", "üa".to_slug.truncate_bytes!(100)
  end

  test "should truncate string by char length" do
    assert_equal "üa", "üa".to_slug.truncate!(2)
    assert_equal "ü",  "üa".to_slug.truncate!(1)
    assert_equal "üa", "üa".to_slug.truncate!(100)
  end

  test "should transliterate uncomposed utf8" do
    string = [117, 776].pack("U*") # "ü" as ASCII "u" plus COMBINING DIAERESIS
    assert_equal "u", string.to_slug.approximate_ascii!
  end

end
