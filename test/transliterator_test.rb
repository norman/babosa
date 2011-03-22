# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class TransliteratorTest < Test::Unit::TestCase

  test "transliterator should be a singleton" do
    assert Babosa::Transliterator::Base.instance
  end

  test "should transliterate" do
    codepoint = "×".unpack("U")[0]
    assert_equal "x", [Babosa::Transliterator::Base.instance[codepoint]].pack("U")
  end

  test "subclasses should also transliterate" do
    codepoint = "×".unpack("U*")[0]
    assert_equal "x", [Babosa::Transliterator::Latin.instance[codepoint]].pack("U")
    codepoint = "À".unpack("U*")[0]
    assert_equal "A", [Babosa::Transliterator::Latin.instance[codepoint]].pack("U")
  end

end
