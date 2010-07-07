# encoding: utf-8
require "rubygems"
require "bundler"
Bundler.setup
require "active_support"
require "rbench"
require File.expand_path("../init", __FILE__)


def sample
  "Ja, żołnierz Wojska Polskiego, przysięgam służyć wiernie Rzeczypospolitej Polskiej".to_slug
end

RBench.run(1000) do

  column :times
  column :time

  report 'Truncate bytes' do
    time { sample.truncate_bytes!(20) }
  end

  report 'Truncate chars' do
    time { sample.truncate!(20) }
  end

  report 'Approximate ASCII' do
    time { sample.approximate_ascii! }
  end

  report 'Approximate with override' do
    time { sample.approximate_ascii!("ć" => "C") }
  end

  report 'Strip non-ASCII' do
    time { sample.to_ascii! }
  end

end
