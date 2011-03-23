$LOAD_PATH << File.expand_path("../lib", __FILE__)
$LOAD_PATH.uniq!

if ENV["coverage"]
  require "simplecov"
  SimpleCov.start
end

# encoding: utf-8
$KCODE = 'UTF8' if RUBY_VERSION < '1.9'

require "rubygems"
require "babosa"
require "active_support"

shared_examples_for "a latin transliterator" do

  let(:t) { described_class.instance }

  it "should transliterate latin characters" do
    string = (0xC0..0x17E).to_a.pack("U*")
    t.transliterate(string).should match(/[\x0-\x7f]/)
  end
end