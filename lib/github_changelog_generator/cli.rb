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
    option :user, :aliases => '-u', :type => :string, :desc => 'Username of the owner of target GitHub repo'
    option :project, :aliases => '-p', :type => :string, :desc => 'Username of the owner of target GitHub repo'
    option :token, :aliases => '-t', :type => :string, :desc => 'To make more than 50 requests per hour your GitHub token required. You can generate it here: https://github.com/settings/tokens/new'
    option :issues_wo_labels, :type => :boolean, :default => true, :desc => 'Include closed issues without labels to changelog.'

    def generate
      print_table([['Project:', 'zanui/chef-thumbor'], ['Username:', 'estahn']])
    end
  end
end