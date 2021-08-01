# frozen_string_literal: true

require_relative "lib/babosa/version"

Gem::Specification.new do |s|
  s.name                  = "babosa"
  s.version               = Babosa::Version::STRING
  s.author                = "Norman Clarke"
  s.email                 = "norman@njclarke.com"
  s.homepage              = "http://github.com/norman/babosa"
  s.required_ruby_version = ">= 2.5.0"
  s.license               = "MIT"

  s.summary           = "A library for creating slugs."
  s.description       = <<-TEXT
    A library for creating slugs. Babosa an extraction and improvement of the
    string code from FriendlyId, intended to help developers create similar
    libraries or plugins.
  TEXT
  s.test_files       = Dir.glob "test/**/*_test.rb"
  s.files            = Dir["lib/**/*.rb", "lib/**/*.rake", "*.md", "MIT-LICENSE",
                           "Rakefile", "init.rb", "generators/**/*.*", "spec/**/*.*", ".gemtest"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", ">= 3.7.0"
  s.add_development_dependency "rubocop", ">= 0.93.0"
  s.add_development_dependency "simplecov"

  s.cert_chain = [File.expand_path("certs/parndt.pem", __dir__)]
  if $PROGRAM_NAME.end_with?("gem") && ARGV.include?("build") && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  end
end
