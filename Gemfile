source "https://rubygems.org"

gemspec

group :development do
end

group :development, :test do
  gem "rake"
  gem "bundler"
  gem "overcommit", ">= 0.31"
  gem "rubocop", ">= 0.43"
end

group :test do
  gem 'rack', '< 2', platform: [:mri_21, :mri_22]
  gem 'rack', '>= 2', platform: :mri_23

  gem "coveralls", "~>0.8", require: false
  gem "simplecov", "~>0.10", require: false
  gem "codeclimate-test-reporter", "~>0.4"
  gem "json"
  gem "rspec", "< 4"
end
