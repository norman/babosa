# frozen_string_literal: true

module Babosa
end

class String
  def to_identifier
    Babosa::Identifier.new self
  end
  alias to_slug to_identifier
end

require "babosa/transliterator/base"
require "babosa/identifier"
