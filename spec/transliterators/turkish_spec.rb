# encoding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe Babosa::Transliterator::Turkish do

  let(:t) { described_class.instance }
  it_behaves_like "a latin transliterator"

  it "should transliterate various characters" do
		examples = {
			"hafıza"     => "hafıza",
			"ÇAĞ" => "ÇAĞ",
			"şarkı" => "şarkı"
		}
    examples.each {|k, v| t.transliterate(k).should eql(v)}
  end
end
