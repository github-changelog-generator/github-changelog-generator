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

describe GitHubChangelogGenerator::Reader do
  before(:all) do
    @reader = GitHubChangelogGenerator::Reader.new
  end

  describe "#parse_heading" do
    context "when heading is empty" do
      subject { @reader.parse_heading("## ") }
      it { is_expected.to be_a(Hash) }
      it { is_expected.to include("version", "url", "date") }
      it { is_expected.to include("version" => nil, "url" => nil, "date" => nil) }
      # TODO: Doesn't work?
      # it { is_expected.to have_all_string_keys }
    end
    context "when given version, url and date" do
      subject { @reader.parse_heading("## [1.3.10](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.10) (2015-03-18)") }
      it { is_expected.to include("version" => "1.3.10") }
      it { is_expected.to include("url" => "https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.10") }
      it { is_expected.to include("date" => "2015-03-18") }
    end
    context "when no url and date is provided" do
      subject { @reader.parse_heading("## foobar") }
      it { is_expected.to include("version" => "foobar", "url" => nil, "date" => nil) }
    end
  end

  describe "#parse" do
    context "when file is empty" do
      subject { @reader.parse("") }
      it { is_expected.to be_an(Array) }
      it { is_expected.to be_empty }
    end
    context "when file has only the header" do
      subject { @reader.parse("# Change Log") }
      it { is_expected.to be_an(Array) }
      it { is_expected.to be_empty }
    end
  end

  describe "example CHANGELOG files" do
    subject { @reader.read(File.expand_path(File.join(File.dirname(__FILE__), "..", "files", self.class.description))) }
    context "github-changelog-generator.md" do
      it { is_expected.to be_an(Array) }
      it { is_expected.not_to be_empty }
      it { expect(subject.count).to eq(28) }
      it { expect(subject.first).to include("version" => "1.3.10") }
      it { expect(subject.first).to include("url" => "https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.10") }
      it { expect(subject.first).to include("date" => "2015-03-18") }
      it { expect(subject.first).to include("content") }
      it "content should not be empty" do
        expect(subject.first["content"]).not_to be_empty
      end
    end
    context "bundler.md" do
      it { is_expected.to be_an(Array) }
      it { is_expected.not_to be_empty }
      it { expect(subject.count).to eq(151) }
      it { expect(subject.first).to include("version" => "1.9.1") }
      it { expect(subject.first).to include("url" => nil) }
      it { expect(subject.first).to include("date" => "2015-03-21") }
      it { expect(subject.first).to include("content") }
      it "content should not be empty" do
        expect(subject.first["content"]).not_to be_empty
      end
    end
    context "angular.js.md" do
      it { is_expected.to be_an(Array) }
      it { is_expected.not_to be_empty }
      # it do
      #   pending('Implement heading_level for parser.')
      #   expect(subject.first).to include('version' => '1.4.0-beta.6 cookie-liberation')
      # end
      # it do
      #   pending('Implement heading_level for parser.')
      #   expect(subject.first).to include('url' => nil)
      # end
      # it do
      #   pending('Implement heading_level for parser.')
      #   expect(subject.first).to include('date' => '2015-03-17')
      # end
      # it do
      #   pending('Implement heading_level for parser.')
      #   expect(subject.first).to include('content')
      # end
      # it 'content should not be empty' do
      #   pending('Implement heading_level for parser.')
      #   expect(subject.first['content']).not_to be_empty
      # end
    end
  end
end
