# frozen_string_literal: true
source "https://rubygems.org"

ruby RUBY_VERSION

gemspec

group :development, :test do
  gem "bundler"
  gem "overcommit"
  gem "rake"
  gem "rubocop"
end

group :development do
  gem "bump"
end

group :test do
  gem "codeclimate-test-reporter"
  gem "coveralls", require: false
  gem "json"
  gem "multi_json"
  gem "rspec"
  gem "simplecov", require: false
  gem "vcr"
  gem "webmock"
end
