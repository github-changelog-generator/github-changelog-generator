# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gemspec

group :development, :test do
  gem "bundler"
  gem "overcommit", ">= 0.60"
  gem "rake"
  gem "rubocop", ">= 1.38"
  gem "rubocop-performance"
  gem "yard-junk"
  gem "byebug"
end

group :development do
  gem "bump"
end

group :test do
  gem "codeclimate-test-reporter", "~> 1.0"
  gem "json"
  gem "rspec", "< 4"
  gem "rspec_junit_formatter"
  gem "simplecov", "~>0.10", require: false
  gem "vcr", "~> 6"
  gem "webmock"
end
