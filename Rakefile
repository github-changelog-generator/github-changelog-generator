require "bundler"
require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"
require "pathname"
require "fileutils"
require "overcommit"

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:rspec)

task :create_man do |_t|
  writable_man_path = Pathname('/etc/manpaths').each_line.find do |line|
    path = Pathname(line.chomp)
    path.directory? && path.writable?
  end rescue nil

  return unless writable_man_path

  man_prefix = Pathname("#{writable_man_path.chomp}/man1")
  man_pages = "man/git-*.1"

  Pathname.glob(man_pages) do |path|
    if path.exist? && man_prefix.exist? && man_prefix.writable?
      FileUtils.cp(path, man_prefix + path.basename)
    end
  end
end

task checks: [:rubocop, :rspec]
task default: [:create_man]
