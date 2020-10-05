require "rubygems"
require "rake/testtask"
require "rake/clean"
require "rubygems/package_task"

task :default => :spec
task :test    => :spec

CLEAN << "pkg" << "doc" << "coverage" << ".yardoc"

begin
  require "yard"
  YARD::Rake::YardocTask.new do |t|
    t.options = ["--output-dir=doc"]
  end
end

begin
  desc "Run SimpleCov"
  task :coverage do
    ENV["COV"] = "true"
    Rake::Task["spec"].execute
  end
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
