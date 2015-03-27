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

require 'thor'

module GitHubChangelogGenerator
  class CLI < Thor
    default_task :generate

    desc 'generate', 'Generates the CHANGELOG.md based on the given options'
    option :user, aliases: '-u', type: :string, desc: 'Username of the owner of target GitHub repo'
    option :project, aliases: '-p', type: :string, desc: 'Username of the owner of target GitHub repo'
    option :token, aliases: '-t', type: :string, desc: 'To make more than 50 requests per hour your GitHub token required. You can generate it here: https://github.com/settings/tokens/new'
    option :date_format, aliases: '-f', type: :string, default: '%d/%m/%y', desc: 'Date format.'
    option :output, aliases: '-o', type: :string, default: 'CHANGELOG.md', desc: 'Output file.'
    # TODO: Should be "closed_issues"
    option :issues, type: :boolean, default: true, desc: 'Include closed issues to changelog.'
    option :issues_wo_labels, type: :boolean, default: true, desc: 'Include closed issues without labels to changelog.'
    option :pr_wo_labels, type: :boolean, default: true, desc: 'Include pull requests without labels to changelog.'
    option :pull_requests, type: :boolean, default: true, desc: 'Include pull-requests to changelog.'
    option :filter_by_milestone, type: :boolean, default: true, desc: 'Use milestone to detect when issue was resolved.'
    option :author, type: :boolean, default: true, desc: 'Add author of pull-request in the end.'
    option :unreleased_only, type: :boolean, default: true, desc: 'Generate log from unreleased closed issues only.'
    option :unreleased, type: :boolean, default: true, desc: 'Add to log unreleased closed issues.'
    option :unreleased_label, type: :boolean, default: true, desc: 'Add to log unreleased closed issues.'
    option :compare_link, type: :boolean, default: true, desc: 'Include compare link (Full Changelog) between older version and newer version.'
    option :include_labels, type: :array, default: %w(bug enhancement), desc: 'Issues only with that labels will be included to changelog.'
    option :exclude_labels, type: :array, default: %w(duplicate question invalid wontfix), desc: 'Issues with that labels will be always excluded from changelog.'
    option :max_issues, type: :numeric, desc: 'Max number of issues to fetch from GitHub. Default is unlimited'
    option :github_site, :banner => 'URL', type: :string, desc: 'The Enterprise Github site on which your project is hosted.'
    option :github_api, :banner => 'URL', type: :string, desc: 'The enterprise endpoint to use for your Github API.'
    option :simple_list, type: :boolean, default: false, desc: 'Create simple list from issues and pull requests.'
    option :verbose, type: :boolean, default: true, desc: 'Run verbosely.'

    long_desc <<-LONGDESC
Automatically generate change log from your tags, issues, labels and pull requests on GitHub.
    LONGDESC
    def generate
    end

    map %w[--version -v] => :__print_version
    desc '--version, -v', 'print the version'
    def __print_version
      puts "Version: #{GitHubChangelogGenerator::VERSION}"
    end
  end
end
