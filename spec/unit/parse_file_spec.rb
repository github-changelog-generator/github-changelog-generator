describe GitHubChangelogGenerator::ParserFile do
  describe ".github_changelog_generator" do
    context "when no has file" do
      let(:options) { {} }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options) }
      subject { parse.parse! }
      it { is_expected.to be_nil }
    end

    context "when file is empty" do
      let(:options) { {} }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options, StringIO.new("")) }

      it "does not change the options" do
        expect { parse.parse! }.to_not change { options }
      end
    end

    context "when file is incorrect" do
      let(:options) { {} }
      let(:options_before_change) { options.dup }
      let(:file) { StringIO.new("unreleased_label=staging\nunreleased: false") }
      let(:parse) do
        GitHubChangelogGenerator::ParserFile.new(options, file)
      end
      it { expect { parse.parse! }.to raise_error(/line #2/) }
    end

    context "when override default values" do
      let(:default_options) { GitHubChangelogGenerator::Parser.default_options }
      let(:options) { {}.merge(default_options) }
      let(:options_before_change) { options.dup }
      let(:file) { StringIO.new("unreleased_label=staging\nunreleased=false\nheader==== Changelog ===") }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options, file) }

      it "changes the options" do
        expect { parse.parse! }.to change { options }
          .from(options_before_change)
          .to(options_before_change.merge(unreleased_label: "staging",
                                          unreleased: false,
                                          header: "=== Changelog ==="))
      end

      context "turns exclude-labels into an Array", bug: '#327' do
        let(:file) do
          StringIO.new(<<EOF
exclude-labels=73a91042-da6f-11e5-9335-1040f38d7f90,7adf83b4-da6f-11e5-ae18-1040f38d7f90
header_label=# My changelog
EOF
                      )
        end
        it "reads exclude_labels into an Array" do
          expect { parse.parse! }.to change { options[:exclude_labels] }
            .from(default_options[:exclude_labels])
            .to(["73a91042-da6f-11e5-9335-1040f38d7f90", "7adf83b4-da6f-11e5-ae18-1040f38d7f90"])
        end

        it "translates given header_label into the :header option" do
          expect { parse.parse! }.to change { options[:header] }
            .from(default_options[:header])
            .to("# My changelog")
        end
      end
    end
  end
end
