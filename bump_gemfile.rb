#!/usr/bin/env ruby
require "optparse"

SPEC_TYPE = "gemspec"

:major
:minor
:patch

@options = { dry_run: false, bump_number: :patch }

OptionParser.new { |opts|
  opts.banner = "Usage: bump.rb [options]"

  opts.on("-d", "--dry-run", "Dry run") do |v|
    @options[:dry_run] = v
  end
  opts.on("-a", "--major", "Bump major version") do |_v|
    @options[:bump_number] = :major
  end
  opts.on("-m", "--minor", "Bump minor version") do |_v|
    @options[:bump_number] = :minor
  end
  opts.on("-p", "--patch", "Bump patch version") do |_v|
    @options[:bump_number] = :patch
  end
  opts.on("-r", "--revert", "Revert last bump") do |v|
    @options[:revert] = v
  end
}.parse!

p @options

def check_repo_is_clean_or_dry_run
  value = `#{"git status --porcelain"}`

  if value.empty?
    puts "Repo is clean -> continue"
  else
    if @options[:dry_run]
      puts 'Repo not clean, "Dry run" enabled -> continue'
    else
      puts "Repository not clean -> exit"
      exit
    end
  end
end

def find_spec_file
  list_of_specs = execute_line("find . -name '*.#{SPEC_TYPE}'")
  arr = list_of_specs.split("\n")

  spec_file = ""

  case arr.count
    when 0
      puts "No #{SPEC_TYPE} files found. -> Exit."
      exit
    when 1
      spec_file = arr[0]
    else
      puts "Which spec should be used?"
      arr.each_with_index { |file, index| puts "#{index + 1}. #{file}" }
      input_index = Integer(gets.chomp)
      spec_file = arr[input_index - 1]
  end

  if spec_file.nil?
    puts "Can't find specified spec file -> exit"
    exit
  end

  spec_file.sub("./", "")
end

def find_current_gem_file
  list_of_specs = execute_line("find . -name '*.gem'")
  arr = list_of_specs.split("\n")

  spec_file = ""

  case arr.count
    when 0
      puts "No #{SPEC_TYPE} files found. -> Exit."
      exit
    when 1
      spec_file = arr[0]
    else
      puts "Which spec should be used?"
      arr.each_with_index { |file, index| puts "#{index + 1}. #{file}" }
      input_index = Integer(gets.chomp)
      spec_file = arr[input_index - 1]
  end

  if spec_file.nil?
    puts "Can't find specified spec file -> exit"
    exit
  end

  spec_file.sub("./", "")
end

def find_version_in_podspec(podspec)
  readme = File.read(podspec)

  # try to find version in format 1.22.333
  re = /(\d+)\.(\d+)\.(\d+)/m

  match_result = re.match(readme)

  unless match_result
    puts "Not found any versions"
    exit
  end

  puts "Found version #{match_result[0]}"
  [match_result[0], match_result.captures]
end

def bump_version(versions_array)
  bumped_result = versions_array.dup
  bumped_result.map!(&:to_i)

  case @options[:bump_number]
    when :major
      bumped_result[0] += 1
      bumped_result[1] = 0
      bumped_result[2] = 0
    when :minor
      bumped_result[1] += 1
      bumped_result[2] = 0
    when :patch
      bumped_result[2] += 1
    else
      fail("unknown bump_number")
  end

  bumped_version = bumped_result.join(".")
  puts "Bump version: #{versions_array.join('.')} -> #{bumped_version}"
  bumped_version
end

def execute_line(line)
  output = `#{line}`
  check_exit_status(output)

  output
end

def execute_line_if_not_dry_run(line)
  if @options[:dry_run]
    puts "Dry run: #{line}"
    nil
  else
    puts line
    value = `#{line}`
    puts value
    check_exit_status(value)
    value
  end
end

def check_exit_status(output)
  if $CHILD_STATUS.exitstatus != 0
    puts "Output:\n#{output}\nExit status = #{$CHILD_STATUS.exitstatus} ->Terminate script."
    exit
  end
end

def run_bumping_script
  check_repo_is_clean_or_dry_run
  spec_file = find_spec_file
  result, versions_array = find_version_in_podspec(spec_file)
  bumped_version = bump_version(versions_array)

  unless @options[:dry_run]
    puts "Are you sure? Press Y to continue:"
    str = gets.chomp
    if str != "Y"
      puts "-> exit"
      exit
    end
  end

  execute_line_if_not_dry_run("sed -i \"\" \"s/#{result}/#{bumped_version}/\" README.md")
  execute_line_if_not_dry_run("sed -i \"\" \"s/#{result}/#{bumped_version}/\" #{spec_file}")
  execute_line_if_not_dry_run("git commit --all -m \"Update #{$SPEC_TYPE} to version #{bumped_version}\"")
  execute_line_if_not_dry_run("git tag #{bumped_version}")
  execute_line_if_not_dry_run("git push")
  execute_line_if_not_dry_run("git push --tags")
  execute_line_if_not_dry_run("gem build #{spec_file}")

  gem = find_current_gem_file
  execute_line_if_not_dry_run("gem push #{gem}")
  # execute_line_if_not_dry_run("pod trunk push #{spec_file}")
end

def revert_last_bump
  spec_file = find_spec_file
  result, _ = find_version_in_podspec(spec_file)

  puts "DELETE tag #{result} and HARD reset HEAD~1?\nPress Y to continue:"
  str = gets.chomp
  if str != "Y"
    puts "-> exit"
    exit
  end
  execute_line_if_not_dry_run("git tag -d #{result}")
  execute_line_if_not_dry_run("git reset --hard HEAD~1")
  execute_line_if_not_dry_run("git push --delete origin #{result}")
end

if __FILE__ == $PROGRAM_NAME

  if @options[:revert]
    revert_last_bump
  else
    run_bumping_script
  end

end
