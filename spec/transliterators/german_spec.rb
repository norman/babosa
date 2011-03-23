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