# frozen_string_literal: true
#
# Author:: Enrico Stahn <mail@enricostahn.com>
#
# Copyright 2014, Zanui, <engineering@zanui.com.au>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require "codeclimate-test-reporter"
require "simplecov"
require "coveralls"
require "vcr"
require "webmock/rspec"

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 Coveralls::SimpleCov::Formatter,
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 CodeClimate::TestReporter::Formatter
                                                               ])
SimpleCov.start do
  add_filter "gemfiles/"
end

require "github_changelog_generator"
require "github_changelog_generator/task"

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = "spec/vcr"
  c.ignore_localhost = true
  c.default_cassette_options = {
    record: :new_episodes,
    serialize_with: :json,
    preserve_exact_body_bytes: true,
    decode_compressed_response: true
  }
  c.filter_sensitive_data("<GITHUB_TOKEN>") do
    "token #{ENV.fetch('CHANGELOG_GITHUB_TOKEN') { 'frobnitz' }}"
  end

  c.configure_rspec_metadata!

  c.hook_into :webmock, :faraday
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.warnings = true

  config.default_formatter = "doc" if config.files_to_run.one?

  config.order = :random

  Kernel.srand config.seed
end
