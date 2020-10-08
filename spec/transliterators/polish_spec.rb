# frozen_string_literal: true

require "spec_helper"

describe Babosa::Transliterator::Romanian do
  let(:t) { described_class.instance }
  it_behaves_like "a latin transliterator"

  it "should transliterate various characters" do
    expect(t.transliterate("ĄąĆćĘęŁłŃńÓóŚśŹźŻż")).to eql("AaCcEeLlNnOoSsZzZz")
  end
end
