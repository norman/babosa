# frozen_string_literal: true

require "spec_helper"

describe Babosa::Transliterator::Danish do
  let(:t) { described_class.instance }
  it_behaves_like "a latin transliterator"

  it "should transliterate various characters" do
    examples = {
      "Ærøskøbing" => "Aeroeskoebing",
      "Årslev"     => "Aarslev"
    }
    examples.each { |k, v| expect(t.transliterate(k)).to eql(v) }
  end
end
