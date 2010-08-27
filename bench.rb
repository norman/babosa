# encoding: utf-8
require "benchmark"
require File.expand_path("../init", __FILE__)

def sample
  "Ja, żołnierz Wojska Polskiego, przysięgam służyć wiernie Rzeczypospolitej Polskiej".to_slug
end
N = 1000
Benchmark.bmbm do |x|
  x.report 'Truncate bytes' do
    N.times do
      sample.truncate_bytes(20)
    end
  end

  x.report 'Truncate chars' do
    N.times do
      sample.truncate(20)
    end
  end

  x.report 'Approximate ASCII' do
    N.times do
      sample.approximate_ascii
    end
  end

  x.report 'Approximate with override' do
    N.times do
      sample.approximate_ascii("ć" => "C")
    end
  end

  x.report 'Strip non-ASCII' do
    N.times do
      sample.to_ascii
    end
  end
end
