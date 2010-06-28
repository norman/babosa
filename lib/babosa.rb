require "babosa/characters"
require "babosa/utf8/proxy"
require "babosa/slug_string"

class String
  def to_slug
    Babosa::SlugString.new self
  end
end
