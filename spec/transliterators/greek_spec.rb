# encoding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe Babosa::Transliterator::Greek do

  let(:t) { described_class.instance }
  it_behaves_like "a greek transliterator"

  it "should transliterate various characters" do
    examples = {
      "Γερμανία"  => "Germania",
      "Αυστρία"   => "Aistria",
      "Ιταλία"    => "Italia"
    }
    examples.each {|k, v| t.transliterate(k).should eql(v)}
  end
end
