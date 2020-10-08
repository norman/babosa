# frozen_string_literal: true

require "spec_helper"

describe Babosa::Transliterator::Swedish do
  let(:t) { described_class.instance }
  it_behaves_like "a latin transliterator"

  it "should transliterate various characters" do
    examples = {
      "Räksmörgås" => "Raeksmoergaas",
      "Öre"        => "Oere",
      "Åre"        => "Aare",
      "Älskar"     => "Aelskar"
    }
    examples.each { |k, v| expect(t.transliterate(k)).to eql(v) }
  end
end
