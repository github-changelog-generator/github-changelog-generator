# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gemspec

group :development, :test do
  gem "bundler", "~> 1.15", ">= 1.15"
  gem "overcommit", "~> 0.39.1", ">= 0.39.1"
  gem "rake", "~> 12.0", ">= 12.0"
  gem "rubocop", "~> 0.49", ">= 0.49"
end

group :development do
  gem "bump"
end

group :test do
  gem "codeclimate-test-reporter", "~> 1.0.7", ">= 1.0.7"
  gem "coveralls", "~> 0.8", ">= 0.8", require: false
  gem "json", "~> 2.1", ">= 2.1"
  gem "multi_json", "~> 1.12.1", ">= 1.12.1"
  gem "rspec", "~> 3.6", ">= 3.6"
  gem "simplecov", "~> 0.14.1", ">= 0.14.1", require: false
  gem "vcr", "~> 3.0.3", ">= 3.0.3"
  gem "webmock", "~> 3.0.1", ">= 3.0.1"
end
