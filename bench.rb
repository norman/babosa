# frozen_string_literal: true
require "benchmark"
require "rubygems"
require "bundler/setup"
require "babosa"

def sample
  "Ja, żołnierz Wojska Polskiego, przysięgam służyć wiernie Rzeczypospolitej Polskiej".to_slug
end
N = 1000
Benchmark.bmbm do |x|
  x.report "Truncate bytes" do
    N.times do
      sample.truncate_bytes(20)
    end
  end

  x.report "Truncate chars" do
    N.times do
      sample.truncate(20)
    end
  end

  x.report "Transliterate" do
    N.times do
      sample.transliterate
    end
  end

  x.report "Strip non-ASCII" do
    N.times do
      sample.to_ascii
    end
  end
end
