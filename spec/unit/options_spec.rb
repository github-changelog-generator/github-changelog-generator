# frozen_string_literal: true
describe GitHubChangelogGenerator::Options do
  it 'can be instantiated with defaults' do
    expect(described_class.new(user: 'olle')[:user]).to eq('olle')
  end

  it 'disallows unknown option names' do
    expect {
      described_class.new(
        git_remote: 'origin',
        strength: 'super-strength',
        wisdom: 'deep'
      )
    }.to raise_error(ArgumentError, "Unsupported options [:strength, :wisdom]")
  end
end
