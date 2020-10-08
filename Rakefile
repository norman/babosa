# frozen_string_literal: true

require "rubygems"
require "rake/testtask"
require "rake/clean"
require "rubygems/package_task"
require "rubocop/rake_task"

task default: [:rubocop, :spec]
task test: :spec

CLEAN << "pkg" << "doc" << "coverage" << ".yardoc"

begin
  require "yard"
  YARD::Rake::YardocTask.new do |t|
    t.options = ["--output-dir=doc"]
  end
rescue LoadError
  puts "Yard not present"
end

begin
  desc "Run SimpleCov"
  task :coverage do
    ENV["COV"] = "true"
    Rake::Task["spec"].execute
  end
rescue LoadError
  puts "SimpleCov not present"
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
