# frozen_string_literal: true

describe GitHubChangelogGenerator::Generator do
  def tag_with_name(tag)
    {
      "name" => tag
    }
  end

  def tags_from_strings(tags_strings)
    tags_strings.map do |tag|
      tag_with_name(tag)
    end
  end

  describe "#detect_link_tag_time" do
    let(:newer_tag) { nil }

    let(:default_options) { GitHubChangelogGenerator::Parser.default_options.merge(verbose: false) }
    let(:options) do
      {
        future_release: "2.0.0"
      }
    end
    let(:generator) { described_class.new(default_options.merge(options)) }

    subject do
      generator.detect_link_tag_time(newer_tag)
    end

    context "When the local date is not the same as the UTC date" do
      before do
        # 2020-12-27T17:00:00-10:00 is 2020-12-28T03:00:00Z.
        # GitHub API date & time use UTC, so this instant when converted as a
        # date should be 2020-12-28.
        expect(Time).to receive(:new).and_return(Time.new(2020, 12, 27, 17, 0, 0, "-10:00"))
      end

      it { is_expected.to eq(["2.0.0", "2.0.0", Time.gm(2020, 12, 28, 3)]) }
    end
  end

  describe "#tag_section_mapping" do
    let(:all_tags) { tags_from_strings(%w[8 7 6 5 4 3 2 1]) }
    let(:sorted_tags) { all_tags }

    let(:default_options) { GitHubChangelogGenerator::Parser.default_options.merge(verbose: false) }
    let(:options) { {} }
    let(:generator) { described_class.new(default_options.merge(options)) }

    before do
      allow_any_instance_of(GitHubChangelogGenerator::OctoFetcher).to receive(:fetch_all_tags).and_return(all_tags)
      allow(generator).to receive(:fetch_tags_dates).with(all_tags)
      allow(generator).to receive(:sort_tags_by_date).with(all_tags).and_return(sorted_tags)
      generator.fetch_and_filter_tags
    end

    subject do
      generator.tag_section_mapping
    end

    shared_examples_for "a section mapping" do
      it { is_expected.to be_a(Hash) }
      it { is_expected.to eq(expected_mapping) }
    end

    shared_examples_for "a full changelog" do
      let(:expected_mapping) do
        {
          tag_with_name("8") => [tag_with_name("7"), tag_with_name("8")],
          tag_with_name("7") => [tag_with_name("6"), tag_with_name("7")],
          tag_with_name("6") => [tag_with_name("5"), tag_with_name("6")],
          tag_with_name("5") => [tag_with_name("4"), tag_with_name("5")],
          tag_with_name("4") => [tag_with_name("3"), tag_with_name("4")],
          tag_with_name("3") => [tag_with_name("2"), tag_with_name("3")],
          tag_with_name("2") => [tag_with_name("1"), tag_with_name("2")],
          tag_with_name("1") => [nil, tag_with_name("1")]
        }
      end

      it_behaves_like "a section mapping"
    end

    shared_examples_for "a changelog with some exclusions" do
      let(:expected_mapping) do
        {
          tag_with_name("8") => [tag_with_name("6"), tag_with_name("8")],
          tag_with_name("6") => [tag_with_name("4"), tag_with_name("6")],
          tag_with_name("4") => [tag_with_name("3"), tag_with_name("4")],
          tag_with_name("3") => [tag_with_name("1"), tag_with_name("3")],
          tag_with_name("1") => [nil, tag_with_name("1")]
        }
      end

      it_behaves_like "a section mapping"
    end

    context "with no constraints" do
      it_behaves_like "a full changelog"
    end

    context "with since only" do
      let(:options) { { since_tag: "6" } }
      let(:expected_mapping) do
        {
          tag_with_name("8") => [tag_with_name("7"), tag_with_name("8")],
          tag_with_name("7") => [tag_with_name("6"), tag_with_name("7")]
        }
      end

      it_behaves_like "a section mapping"
    end

    context "with due only" do
      let(:options) { { due_tag: "4" } }
      let(:expected_mapping) do
        {
          tag_with_name("3") => [tag_with_name("2"), tag_with_name("3")],
          tag_with_name("2") => [tag_with_name("1"), tag_with_name("2")],
          tag_with_name("1") => [nil, tag_with_name("1")]
        }
      end

      it_behaves_like "a section mapping"
    end

    context "with since and due" do
      let(:options) { { since_tag: "2", due_tag: "5" } }
      let(:expected_mapping) do
        {
          tag_with_name("4") => [tag_with_name("3"), tag_with_name("4")],
          tag_with_name("3") => [tag_with_name("2"), tag_with_name("3")]
        }
      end

      it_behaves_like "a section mapping"
    end

    context "with excluded tags" do
      context "as a list of strings" do
        let(:options) { { exclude_tags: %w[2 5 7] } }

        it_behaves_like "a changelog with some exclusions"
      end

      context "as a regex" do
        let(:options) { { exclude_tags: /[257]/ } }

        it_behaves_like "a changelog with some exclusions"
      end

      context "as a regex string" do
        let(:options) { { exclude_tags_regex: "[257]" } }

        it_behaves_like "a changelog with some exclusions"
      end
    end
  end

  describe "#filter_included_tags_regex" do
    subject { generator.filter_included_tags(tags_from_strings(%w[1 2 3])) }

    context "with matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(include_tags_regex: "[23]") }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w[2 3])) }
    end

    context "with non-matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(include_tags_regex: "[45]") }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w[])) }
    end
  end

  describe "#filter_excluded_tags" do
    subject { generator.filter_excluded_tags(tags_from_strings(%w[1 2 3])) }

    context "with matching string" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: %w[3]) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w[1 2])) }
    end

    context "with non-matching string" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: %w[invalid tags]) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w[1 2 3])) }
    end

    context "with matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: /[23]/) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w[1])) }
    end

    context "with non-matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: /[abc]/) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w[1 2 3])) }
    end
  end

  describe "#filter_excluded_tags_regex" do
    subject { generator.filter_excluded_tags(tags_from_strings(%w[1 2 3])) }

    context "with matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags_regex: "[23]") }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w[1])) }
    end

    context "with non-matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags_regex: "[45]") }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w[1 2 3])) }
    end
  end

  describe "#filter_since_tag" do
    context "with filled array" do
      subject { generator.filter_since_tag(tags_from_strings(%w[1 2 3])) }

      context "with valid since tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(since_tag: "2") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w[1 2])) }

        context "with since tag set to the most recent tag" do
          let(:generator) { GitHubChangelogGenerator::Generator.new(since_tag: "1") }
          it { is_expected.to match_array(tags_from_strings(%w[1])) }
        end
      end

      context "with invalid since tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(since_tag: "Invalid tag") }
        it { expect { subject }.to raise_error(GitHubChangelogGenerator::ChangelogGeneratorError) }
      end
    end

    context "with empty array" do
      subject { generator.filter_since_tag(tags_from_strings(%w[])) }

      context "with invalid since tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(since_tag: "Invalid tag") }
        it { expect { subject }.to raise_error(GitHubChangelogGenerator::ChangelogGeneratorError) }
      end
    end
  end

  describe "#filter_due_tag" do
    context "with filled array" do
      subject { generator.filter_due_tag(tags_from_strings(%w[1 2 3])) }

      context "with valid due tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(due_tag: "2") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w[3])) }
      end

      context "with invalid due tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(due_tag: "Invalid tag") }
        it { expect { subject }.to raise_error(GitHubChangelogGenerator::ChangelogGeneratorError) }
      end
    end

    context "with empty array" do
      subject { generator.filter_due_tag(tags_from_strings(%w[])) }

      context "with invalid due tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(due_tag: "Invalid tag") }
        it { expect { subject }.to raise_error(GitHubChangelogGenerator::ChangelogGeneratorError) }
      end
    end
  end

  describe "#get_time_of_tag" do
    current_time = Time.now
    before(:all) { @generator = GitHubChangelogGenerator::Generator.new }
    context "run with nil parameter" do
      it "should raise ChangelogGeneratorError" do
        expect { @generator.get_time_of_tag nil }.to raise_error(GitHubChangelogGenerator::ChangelogGeneratorError)
      end
    end
    context "fetch already filled tag" do
      before { @generator.instance_variable_set :@tag_times_hash, "valid_tag" => current_time }
      subject { @generator.get_time_of_tag tag_with_name("valid_tag") }
      it { is_expected.to be_a_kind_of(Time) }
      it { is_expected.to eq(current_time) }
    end
    context "fetch not filled tag" do
      before do
        mock = double("fake fetcher")
        allow(mock).to receive_messages(fetch_date_of_tag: current_time)
        @generator.instance_variable_set :@fetcher, mock
      end
      subject do
        of_tag = @generator.get_time_of_tag(tag_with_name("valid_tag"))
        of_tag
      end
      it { is_expected.to be_a_kind_of(Time) }
      it { is_expected.to eq(current_time) }
    end
  end

  describe "#sort_tags_by_date" do
    let(:time1) { Time.now }
    let(:time2) { Time.now }
    let(:time3) { Time.now }

    before(:all) do
      @generator = GitHubChangelogGenerator::Generator.new
    end

    before do
      @generator.instance_variable_set(:@tag_times_hash, "valid_tag1" => time1,
                                                         "valid_tag2" => time2,
                                                         "valid_tag3" => time3)
    end

    subject do
      @generator.sort_tags_by_date(tags)
    end
    context "sort unsorted tags" do
      let(:tags) { tags_from_strings %w[valid_tag1 valid_tag2 valid_tag3] }

      it { is_expected.to be_a_kind_of(Array) }
      it { is_expected.to match_array(tags.reverse!) }
    end
    context "sort sorted tags" do
      let(:tags) { tags_from_strings %w[valid_tag3 valid_tag2 valid_tag1] }

      it { is_expected.to be_a_kind_of(Array) }
      it { is_expected.to match_array(tags) }
    end
  end
end
