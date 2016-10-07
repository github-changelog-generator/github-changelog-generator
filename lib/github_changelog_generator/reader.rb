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

module GitHubChangelogGenerator
  # A Reader to read an existing ChangeLog file and return a structured object
  #
  # Example:
  #   reader = GitHubChangelogGenerator::Reader.new
  #   content = reader.read('./CHANGELOG.md')
  class Reader
    def initialize(options = {})
      defaults = {
        heading_level: "##",
        heading_structures: [
          /^## \[(?<version>.+?)\]\((?<url>.+?)\)( \((?<date>.+?)\))?$/,
          /^## (?<version>.+?)( \((?<date>.+?)\))?$/
        ]
      }

      @options = options.merge(defaults)

      @heading_level = @options[:heading_level]
      @heading_structures = @options[:heading_structures]
    end

    # Parse a single heading and return a Hash
    #
    # The following heading structures are currently valid:
    # - ## [v1.0.2](https://github.com/zanui/chef-thumbor/tree/v1.0.1) (2015-03-24)
    # - ## [v1.0.2](https://github.com/zanui/chef-thumbor/tree/v1.0.1)
    # - ## v1.0.2 (2015-03-24)
    # - ## v1.0.2
    #
    # @param [String] heading Heading from the ChangeLog File
    # @return [Hash] Returns a structured Hash with version, url and date
    def parse_heading(heading)
      captures = { "version" => nil, "url" => nil, "date" => nil }

      @heading_structures.each do |regexp|
        matches = Regexp.new(regexp).match(heading)
        if matches
          captures.merge!(Hash[matches.names.zip(matches.captures)])
          break
        end
      end

      captures
    end

    # Parse the given ChangeLog data into a list of Hashes
    #
    # @param [String] data File data from the ChangeLog.md
    # @return [Array<Hash>] Parsed data, e.g. [{ 'version' => ..., 'url' => ..., 'date' => ..., 'content' => ...}, ...]
    def parse(data)
      sections = data.split(/^## .+?$/)
      headings = data.scan(/^## .+?$/)

      headings.each_with_index.map do |heading, index|
        section = parse_heading(heading)
        section["content"] = sections.at(index + 1)
        section
      end
    end

    def read(file_path)
      parse File.read(file_path)
    end
  end
end
