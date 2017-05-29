# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gemspec

group :development, :test do
  gem "bundler", "1.15.0"
  gem "overcommit", "0.39.1"
  gem "rake", "12.0.0"
  gem "rubocop", "0.49"
end

group :development do
  gem "bump"
end

group :test do
  gem "codeclimate-test-reporter", "1.0.8"
  gem "coveralls", "0.8.21", require: false
  gem "json", "2.1.0"
  gem "multi_json", "1.12.1"
  gem "rspec", "3.6.0"
  gem "simplecov", "<= 0.13", require: true
  gem "vcr", "3.0.3"
  gem "webmock", "3.0.1"
end
