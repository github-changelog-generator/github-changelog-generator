# frozen_string_literal: true
require "bundler"
require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"
require "pathname"
require "fileutils"
require "overcommit"

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:rspec)

task :copy_man_page_to_manpath do |_t|
  known_manpath_paths = %w(/etc/manpath.config /etc/manpaths)
  manpath = known_manpath_paths.find do |f|
    path = Pathname(f)
    path.file? && path.readable?
  end

  next unless manpath

  writable_man_path = Pathname(manpath).each_line.find do |line|
    path = Pathname(line.chomp)
    path.directory? && path.writable?
  end

  next unless writable_man_path

  man_prefix = Pathname("#{writable_man_path.chomp}/man1")
  man_pages = "man/git-*.1"

  Pathname.glob(man_pages) do |path|
    if path.exist? && man_prefix.exist? && man_prefix.writable?
      FileUtils.cp(path, man_prefix + path.basename)
    end
  end
end

task checks: [:rubocop, :rspec]
task default: [:rubocop, :rspec]
