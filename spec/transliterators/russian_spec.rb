# frozen_string_literal: true

require "spec_helper"

describe Babosa::Transliterator::Russian do
  let(:t) { described_class.instance }
  it_behaves_like "a cyrillic transliterator"
end
