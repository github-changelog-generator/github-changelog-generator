# frozen_string_literal: true

describe GitHubChangelogGenerator::ParserFile do
  describe ".github_changelog_generator" do
    let(:options) { {} }
    let(:parser) { described_class.new(options, StringIO.new(file)) }

    context "when the well-known default file does not exist" do
      let(:parser) { described_class.new(options) }

      subject { parser.parse! }

      it { is_expected.to be_nil }
    end

    context "when file is empty" do
      let(:file) { "" }

      it "does not change the options" do
        expect { parser.parse! }.to_not(change { options })
      end
    end

    context "when file is incorrect" do
      let(:file) do
        <<~FILE.strip
          unreleased_label=staging
          unreleased: false
        FILE
      end

      it { expect { parser.parse! }.to raise_error(/line #2/) }
    end

    context "allows empty lines and comments with semi-colon or pound sign" do
      let(:file) do
        "\n   \n#{<<~REMAINING.strip}"
          # Comment on first line
          unreleased_label=staging
          ; Comment on third line
          unreleased=false
        REMAINING
      end

      it { expect { parser.parse! }.not_to raise_error }
    end

    context "when override default values" do
      let(:default_options) { GitHubChangelogGenerator::Parser.default_options.merge(verbose: false) }
      let(:options) { {}.merge(default_options) }
      let(:options_before_change) { options.dup }
      let(:file) do
        <<~FILE.strip
          unreleased_label=staging
          unreleased=false
          header==== Changelog ===
          max_issues=123
          simple-list=true
        FILE
      end

      it "changes the options" do
        expect { parser.parse! }.to change { options }
          .from(options_before_change)
          .to(options_before_change.merge(unreleased_label: "staging",
                                          unreleased: false,
                                          header: "=== Changelog ===",
                                          max_issues: 123,
                                          simple_list: true))
      end

      context "turns exclude-labels into an Array", bug: "#327" do
        let(:file) do
          <<~FILE
            exclude-labels=73a91042-da6f-11e5-9335-1040f38d7f90,7adf83b4-da6f-11e5-ae18-1040f38d7f90
            header_label=# My changelog
          FILE
        end

        it "reads exclude_labels into an Array" do
          expect { parser.parse! }.to change { options[:exclude_labels] }
            .from(default_options[:exclude_labels])
            .to(%w[73a91042-da6f-11e5-9335-1040f38d7f90 7adf83b4-da6f-11e5-ae18-1040f38d7f90])
        end

        it "translates given header_label into the :header option" do
          expect { parser.parse! }.to change { options[:header] }
            .from(default_options[:header])
            .to("# My changelog")
        end
      end
    end
  end
end
