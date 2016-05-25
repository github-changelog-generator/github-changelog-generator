# frozen_string_literal: true
describe GitHubChangelogGenerator::Generator do
  def tag_with_name(tag)
    {}.tap { |mash_tag| mash_tag["name"] = tag }
  end

  def tags_from_strings(tags_strings)
    tags_strings.map do |tag|
      tag_with_name(tag)
    end
  end

  describe "#filter_between_tags" do
    context "when between_tags nil" do
      before do
        @generator = GitHubChangelogGenerator::Generator.new(between_tags: nil)
      end

      subject do
        @generator.get_filtered_tags(tags_from_strings(%w(1 2 3)))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(tags_from_strings(%w(1 2 3))) }
    end
    context "when between_tags same as input array" do
      before do
        @generator = GitHubChangelogGenerator::Generator.new(between_tags: %w(1 2 3))
      end
      subject do
        @generator.get_filtered_tags(tags_from_strings(%w(1 2 3)))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(tags_from_strings(%w(1 2 3))) }
    end

    context "when between_tags filled with correct values" do
      before do
        @generator = GitHubChangelogGenerator::Generator.new(between_tags: %w(1 2))
      end
      subject do
        @generator.get_filtered_tags(tags_from_strings(%w(1 2 3)))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(tags_from_strings(%w(1 2))) }
    end

    context "when between_tags filled with invalid values" do
      before do
        @generator = GitHubChangelogGenerator::Generator.new(between_tags: %w(1 q w))
      end

      subject do
        @generator.get_filtered_tags(tags_from_strings(%w(1 2 3)))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(tags_from_strings(%w(1))) }
    end
  end

  describe "#get_filtered_tags" do
    subject do
      generator.get_filtered_tags(tags_from_strings(%w(1 2 3 4 5)))
    end

    context "with excluded and between tags" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(between_tags: %w(1 2 3), exclude_tags: %w(2)) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w(1 3))) }
    end
  end

  describe "#filter_excluded_tags" do
    subject { generator.filter_excluded_tags(tags_from_strings(%w(1 2 3))) }

    context "with matching string" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: %w(3)) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w(1 2))) }
    end

    context "with non-matching string" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: %w(invalid tags)) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w(1 2 3))) }
    end

    context "with matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: /[23]/) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w(1))) }
    end

    context "with non-matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: /[abc]/) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w(1 2 3))) }
    end
  end

  describe "#filter_excluded_tags_regex" do
    subject { generator.filter_excluded_tags(tags_from_strings(%w(1 2 3))) }

    context "with matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags_regex: "[23]") }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w(1))) }
    end

    context "with non-matching regex" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags_regex: "[45]") }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(tags_from_strings(%w(1 2 3))) }
    end
  end

  describe "#filter_since_tag" do
    context "with filled array" do
      subject { generator.filter_since_tag(tags_from_strings(%w(1 2 3))) }

      context "with valid since tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(since_tag: "2") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w(1))) }
      end

      context "with invalid since tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(since_tag: "Invalid tag") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w(1 2 3))) }
      end
    end

    context "with empty array" do
      subject { generator.filter_since_tag(tags_from_strings(%w())) }

      context "with valid since tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(since_tag: "2") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w())) }
      end

      context "with invalid since tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(since_tag: "Invalid tag") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w())) }
      end
    end
  end

  describe "#filter_due_tag" do
    context "with filled array" do
      subject { generator.filter_due_tag(tags_from_strings(%w(1 2 3))) }

      context "with valid due tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(due_tag: "2") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w(3))) }
      end

      context "with invalid due tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(due_tag: "Invalid tag") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w(1 2 3))) }
      end
    end

    context "with empty array" do
      subject { generator.filter_due_tag(tags_from_strings(%w())) }

      context "with valid due tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(due_tag: "2") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w())) }
      end

      context "with invalid due tag" do
        let(:generator) { GitHubChangelogGenerator::Generator.new(due_tag: "Invalid tag") }
        it { is_expected.to be_a Array }
        it { is_expected.to match_array(tags_from_strings(%w())) }
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
      let(:tags) { tags_from_strings %w(valid_tag1 valid_tag2 valid_tag3) }

      it { is_expected.to be_a_kind_of(Array) }
      it { is_expected.to match_array(tags.reverse!) }
    end
    context "sort sorted tags" do
      let(:tags) { tags_from_strings %w(valid_tag3 valid_tag2 valid_tag1) }

      it { is_expected.to be_a_kind_of(Array) }
      it { is_expected.to match_array(tags) }
    end
  end
end
