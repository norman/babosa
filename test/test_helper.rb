# encoding: utf-8
$KCODE = 'UTF8' if RUBY_VERSION < '1.9'

require "rubygems"
require "bundler/setup"
require "test/unit"
require "babosa"

Module.send :include, Module.new {
  def test(name, &block)
    define_method("test_#{name.gsub(/[^a-z0-9_]/i, "_")}".to_sym, &block)
  end
}