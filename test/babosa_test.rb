# encoding: utf-8
$KCODE = 'UTF8' if RUBY_VERSION < '1.9'

require "rubygems"
require "bundler/setup"
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

if Babosa.jruby15?
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

  test "should respond_to? :empty?" do
    assert "".to_slug.respond_to? :empty?
  end

  test "word_chars! should leave only letters and spaces" do
    string = "a*$%^$@!@b$%^&*()*!c"
    assert_match /[a-z ]*/i, string.to_slug.word_chars!
  end

  test "approximate_ascii should transliterate to ascii" do
    slug = (0xC0..0x17E).to_a.each do |codepoint|
      ss = [codepoint].pack("U*").to_slug
      approx = ss.approximate_ascii
      assert_match /[\x0-\x7f]/, approx.to_s
    end
  end

  test "should lowercase strings" do
    assert_equal "feliz año", "FELIZ AÑO".to_slug.downcase!
  end

  test "should uppercase strings" do
    assert_equal "FELIZ AÑO", "feliz año".to_slug.upcase!
  end

  test "should replace whitespace with dashes" do
    assert_equal "a-b", "a b".to_slug.clean.normalize!
  end

  test "should replace multiple spaces with 1 dash" do
    assert_equal "a-b", "a    b".to_slug.clean.normalize!
  end

  test "should replace multiple dashes with 1 dash" do
    assert_equal "male-female", "male - female".to_slug.normalize!
  end

  test "should strip trailing space" do
    assert_equal "ab", "ab ".to_slug.normalize!
  end

  test "should strip leading space" do
    assert_equal "ab", " ab".to_slug.normalize!
  end

  test "should strip trailing slashes" do
    assert_equal "ab", "ab-".to_slug.normalize!
  end

  test "should strip leading slashes" do
    assert_equal "ab", "-ab".to_slug.normalize!
  end

  test "should not modify valid name strings" do
    assert_equal "a-b-c-d", "a-b-c-d".to_slug.normalize!
  end

  test "should do special approximations for German" do
    {
      "Jürgen" => "Juergen",
      "böse"   => "boese",
      "Männer" => "Maenner"
    }.each {|given, expected| assert_equal expected, given.to_slug.approximate_ascii!(:german)}
  end

  test "should do special approximations for Spanish" do
    assert_equal "anio", "año".to_slug.approximate_ascii!(:spanish)
  end

  test "should do special approximations for Serbian" do
    {
      "Ðorđe"  => "Djordje",
      "Inđija" => "Indjija",
      "Četiri" => "Chetiri",
      "četiri" => "chetiri",
      "Škola"  => "Shkola",
      "škola"  => "shkola"
    }.each {|given, expected| assert_equal expected, given.to_slug.approximate_ascii!(:serbian)}
  end

  test "should do special approximations for Danish" do
    {
      "Ærøskøbing" => "Aeroeskoebing",
      "Årslev"       => "Aarslev"
    }.each {|given, expected| assert_equal expected, given.to_slug.approximate_ascii!(:danish)}
  end

  test "should work with non roman chars" do
    assert_equal "検-索", "検 索".to_slug.normalize!
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
    assert_equal "ü",  "üéøá".to_slug.truncate_bytes!(3)
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

  test "with_dashes should not change byte size when replacing spaces" do
    assert_equal "".bytesize, "".to_slug.with_dashes.bytesize
    assert_equal " ".bytesize, " ".to_slug.with_dashes.bytesize
    assert_equal "-abc-".bytesize, "-abc-".to_slug.with_dashes.bytesize
    assert_equal " abc ".bytesize, " abc ".to_slug.with_dashes.bytesize
    assert_equal " a  bc ".bytesize, " a  bc ".to_slug.with_dashes.bytesize
  end

  test "normalize! with ascii option should approximate and strip non ascii" do
    ss = "カタカナ: katakana is über cool".to_slug
    assert_equal "katakana-is-uber-cool", ss.normalize!(:to_ascii => true)
  end

  test "normalize should use transliterations" do
    assert_equal "juergen", "Jürgen".to_slug.normalize(:transliterations => :german).to_s
  end

  test "should get a string suitable for use as a ruby method" do
    assert_equal "hello_world?", "¿¿¿hello... world???".to_slug.to_ruby_method!
    assert_equal "katakana_is_uber_cool", "カタカナ: katakana is über cool".to_slug.to_ruby_method!
    assert_equal "katakana_is_uber_cool!", "カタカナ: katakana is über cool!".to_slug.to_ruby_method!
    assert_equal "katakana_is_uber_cool", "カタカナ: katakana is über cool".to_slug.to_ruby_method!(false)
  end

  test "should approximate 'smart' quotes" do
    assert_equal "john's", "john’s".to_slug.approximate_ascii.to_s
    assert_equal "johns", "john’s".to_slug.normalize.to_s
  end
end
