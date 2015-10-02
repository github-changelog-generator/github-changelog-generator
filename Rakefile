require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"
require "pathname"
require "fileutils"

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:rspec)

task :create_man do |_t|
  os_prefix = "/usr/local"
  man_prefix = Pathname("#{os_prefix}/share/man/man1")
  man_pages = "man/git-*"

  Pathname.glob(man_pages) do |path|
    FileUtils.cp(path, man_prefix + path.basename)
  end
end

task checks: [:rubocop, :rspec]
task default: [:checks, :create_man]
