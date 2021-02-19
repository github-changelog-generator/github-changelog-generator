# frozen_string_literal: true

require "bundler"
require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"
require "pathname"
require "fileutils"
require "overcommit"

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new

desc "When releasing the gem, re-fetch latest cacert.pem from curl.haxx.se. Developer task."
task :update_ssl_ca_file do
  `pushd lib/github_changelog_generator/ssl_certs && curl --remote-name --time-cond cacert.pem https://curl.se/ca/cacert.pem && popd`
end

task default: %i[rubocop spec]
