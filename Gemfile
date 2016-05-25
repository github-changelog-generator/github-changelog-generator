# frozen_string_literal: true
source "https://rubygems.org"

gemspec

group :development, :test do
  gem "rake"
  gem "bundler"
  gem "overcommit", ">= 0.31"
  gem "rubocop", ">= 0.43"
end

group :development do
  gem "bump"
end

group :test do
  gem "vcr"
  gem "multi_json"
  gem "webmock"
  gem "coveralls", "~>0.8", require: false
  gem "simplecov", "~>0.10", require: false
  gem "codeclimate-test-reporter", "~>0.4"
  if RUBY_VERSION > "2"
    gem "json", "~> 2.0", ">= 2.0.2"
  else
    gem "json"
  end
  gem "rspec", "< 4"
end
