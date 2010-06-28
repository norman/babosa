# encoding: utf-8
require "rubygems"
require "rbench"
require "unicode"
require File.expand_path("../init", __FILE__)

SAMPLE = "Ja, żołnierz Wojska Polskiego, przysięgam służyć wiernie Rzeczypospolitej Polskiej".to_slug

RBench.run(10_000) do

  column :times
  column :time

  report 'Truncate bytes' do
    time { SAMPLE.truncate_bytes(20) }
  end

  report 'Truncate chars' do
    time { SAMPLE.truncate(20) }
  end

  report 'Approximate ASCII' do
    time { SAMPLE.approximate_ascii }
  end

  report 'Approximate with override' do
    time { SAMPLE.approximate_ascii("ć" => "C") }
  end

  report 'Strip non-ASCII' do
    time { SAMPLE.to_ascii }
  end

  report 'Make truncated ASCII slug' do
    time { SAMPLE.approximate_ascii.truncate_bytes(100).normalize }
  end

end
