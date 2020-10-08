# frozen_string_literal: true

require "spec_helper"

describe Babosa::Transliterator::Vietnamese do
  let(:t) { described_class.instance }
  it_behaves_like "a latin transliterator"

  it "should transliterate various characters" do
    examples = {
      "làm"     => "lam",
      "đàn ông" => "dan ong",
      "thật"    => "that",
      "khổ"     => "kho"
    }
    examples.each { |k, v| expect(t.transliterate(k)).to eql(v) }
  end
end
