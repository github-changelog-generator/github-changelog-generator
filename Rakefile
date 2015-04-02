require "rubocop/rake_task"
require "rspec/core/rake_task"

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:rspec)

task default: [:rubocop, :rspec]
