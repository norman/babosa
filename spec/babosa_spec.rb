# encoding: utf-8
require File.expand_path("../spec_helper", __FILE__)

describe Babosa::Identifier do

  it "should respond_to :empty?" do
    "".to_slug.should respond_to(:empty?)
  end

  %w[approximate_ascii clean downcase word_chars normalize to_ascii upcase with_dashes].each do |method|
    describe "##{method}" do
      it "should work with invalid UTF-8 strings" do
        expect {"\x93abc".to_slug.send method}.not_to raise_exception
      end
    end
  end

  describe "#word_chars" do
    it "word_chars! should leave only letters and spaces" do
      string = "a*$%^$@!@b$%^&*()*!c"
      string.to_slug.word_chars.should match(/[a-z ]*/i)
    end
  end

  describe "#transliterate" do
    it "should transliterate to ascii" do
      slug = (0xC0..0x17E).to_a.each do |codepoint|
        ss = [codepoint].pack("U*").to_slug
        ss.approximate_ascii.should match(/[\x0-\x7f]/)
      end
    end

    it "should transliterate uncomposed utf8" do
      string = [117, 776].pack("U*") # "ü" as ASCII "u" plus COMBINING DIAERESIS
      string.to_slug.approximate_ascii.should eql("u")
    end

    it "should transliterate using multiple transliterators" do
      string = "свободное režģis"
      string.to_slug.approximate_ascii(:latin, :russian).should eql("svobodnoe rezgis")
    end
  end

  describe "#downcase" do
    it "should lowercase strings" do
      "FELIZ AÑO".to_slug.downcase.should eql("feliz año")
    end
  end

  describe "#upcase" do
    it "should uppercase strings" do
      "feliz año".to_slug.upcase.should eql("FELIZ AÑO")
    end
  end

  describe "#normalize" do

    it "should allow passing locale as key for :transliterate" do
      "ö".to_slug.clean.normalize(:transliterate => :german).should eql("oe")
    end

    it "should replace whitespace with dashes" do
      "a b".to_slug.clean.normalize.should eql("a-b")
    end

    it "should replace multiple spaces with 1 dash" do
      "a    b".to_slug.clean.normalize.should eql("a-b")
    end

    it "should replace multiple dashes with 1 dash" do
      "male - female".to_slug.normalize.should eql("male-female")
    end

    it "should strip trailing space" do
      "ab ".to_slug.normalize.should eql("ab")
    end

    it "should strip leading space" do
      " ab".to_slug.normalize.should eql("ab")
    end

    it "should strip trailing slashes" do
      "ab-".to_slug.normalize.should eql("ab")
    end

    it "should strip leading slashes" do
      "-ab".to_slug.normalize.should eql("ab")
    end

    it "should not modify valid name strings" do
      "a-b-c-d".to_slug.normalize.should eql("a-b-c-d")
    end

    it "should not convert underscores" do
      "hello_world".to_slug.normalize.should eql("hello_world")
    end

    it "should work with non roman chars" do
      "検 索".to_slug.normalize.should eql("検-索")
    end

    context "with to_ascii option" do
      it "should approximate and strip non ascii" do
        ss = "カタカナ: katakana is über cool".to_slug
        ss.normalize(:to_ascii => true).should eql("katakana-is-uber-cool")
      end
    end
  end

  describe "#truncate_bytes" do
    it "should by byte length" do
      "üa".to_slug.truncate_bytes(2).should eql("ü")
      "üa".to_slug.truncate_bytes(1).should eql("")
      "üa".to_slug.truncate_bytes(100).should eql("üa")
      "üéøá".to_slug.truncate_bytes(3).should eql("ü")
    end
  end

  describe "#truncate" do
    it "should truncate by char length" do
      "üa".to_slug.truncate(2).should eql("üa")
      "üa".to_slug.truncate(1).should eql("ü")
      "üa".to_slug.truncate(100).should eql("üa")
    end
  end

  describe "#with_dashes" do
    it "should not change byte size when replacing spaces" do
      "".to_slug.with_dashes.bytesize.should eql(0)
      " ".to_slug.with_dashes.bytesize.should eql(1)
      "-abc-".to_slug.with_dashes.bytesize.should eql(5)
      " abc ".to_slug.with_dashes.bytesize.should eql(5)
      " a  bc ".to_slug.with_dashes.bytesize.should eql(7)
    end
  end

  describe "#to_ruby_method" do
    it "should get a string suitable for use as a ruby method" do
      "¿¿¿hello... world???".to_slug.to_ruby_method.should eql("hello_world?")
      "カタカナ: katakana is über cool".to_slug.to_ruby_method.should eql("katakana_is_uber_cool")
      "カタカナ: katakana is über cool!".to_slug.to_ruby_method.should eql("katakana_is_uber_cool!")
      "カタカナ: katakana is über cool".to_slug.to_ruby_method(false).should eql("katakana_is_uber_cool")
    end
  end
end