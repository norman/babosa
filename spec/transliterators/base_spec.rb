# encoding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe Babosa::Transliterator::Base do

  before { @t = Babosa::Transliterator::Base.instance }

  it "should transliterate 'smart' quotes" do
    @t.transliterate("’").should eql("'")
  end

  it "should transliterate non-breaking spaces" do
    @t.transliterate("\xc2\xa0").should eql(" ")
  end

end