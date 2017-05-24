# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gemspec

group :development, :test do
  gem "bundler"
  gem "overcommit", "~> 0.39.1"
  gem "rake"
  gem "rubocop", "~> 0.49"
end

group :development do
  gem "bump"
end

group :test do
  gem "codeclimate-test-reporter", "~> 1.0.8"
  gem "coveralls", "~> 0.8.21", require: false
  gem "json"
  gem "multi_json"
  gem "rspec", "~> 3.6.0"
  gem "simplecov", "~> 0.14", require: false
  gem "vcr"
  gem "webmock"
end
