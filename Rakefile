require "rake/testtask"
require "rake/clean"

CLEAN << "pkg" << "doc" << "coverage" << ".yardoc"
Rake::TestTask.new(:test) { |t| t.pattern = "test/**/*_test.rb" }
