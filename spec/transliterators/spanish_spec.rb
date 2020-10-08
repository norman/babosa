# frozen_string_literal: true

require "spec_helper"

describe Babosa::Transliterator::Spanish do
  let(:t) { described_class.instance }
  it_behaves_like "a latin transliterator"

  it "should transliterate ñ" do
    expect(t.transliterate("ñ")).to eql("ni")
  end
end
