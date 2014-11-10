#!/usr/bin/env ruby
require 'optparse'

SPEC_TYPE = 'gemspec'

@options = {:dry_run => false, :major => false, :minor => false, :patch => true}

OptionParser.new { |opts|
  opts.banner = 'Usage: bump.rb [options]'

  opts.on('-d', '--dry-run', 'Dry run') do |v|
    @options[:dry_run] = v
  end
  opts.on('-a', '--major', 'Bump major version') do |v|
    @options[:major] = v
  end
  opts.on('-m', '--minor', 'Bump minor version') do |v|
    @options[:minor] = v
  end
  opts.on('-p', '--patch', 'Bump patch version') do |v|
    @options[:patch] = v
  end
}.parse!

p @options

def check_repo_is_clean_or_dry_run
  value =%x[#{'git status --porcelain'}]

  if value.empty?
    puts 'Repo is clean -> continue'
  else
    if @options[:dry_run]
      puts 'Repo not clean, "Dry run" enabled -> continue'
    else
      puts 'Repository not clean -> exit'
      exit
    end
  end
end

def execute_line(line)
  output = `#{line}`
  if $?.exitstatus != 0
    puts "Output:\n#{output}\nExit status = #{$?.exitstatus} ->Terminate script."
  end

  output
end

def find_spec_file
  list_of_scpecs = execute_line("find . -name '*.#{SPEC_TYPE}'")
  arr = list_of_scpecs.split("\n")

  spec_file = ''

  case arr.count
    when 0
      puts "No #{SPEC_TYPE} files found. -> Exit."
      exit
    when 1
      spec_file = arr[0]
    else
      puts 'Which spec should be used?'
      arr.each_with_index {|file, index| puts "#{index+1}. #{file}"}
      input_index = Integer(gets.chomp)
      spec_file = arr[input_index-1]
  end

  if spec_file == nil
    puts "Can't find specified spec file -> exit"
    exit
  end

  spec_file.sub('./', '')

end

def find_version_in_podspec(podspec)
  readme = File.read(#{podspec})

  re = /(\d+)\.(\d+)\.(\d+)/m

  match_result = re.match(readme)

  unless match_result
    puts 'Not found any versions'
    exit
  end

  puts "Found version #{match_result[0]}"
  p match_result[0], match_result.captures
  exit
  # return match_result[0], match_result.captures
end

def bump_version(result_array)
  bumped_result = result_array.dup
  bumped_result.map! { |x| x.to_i }

  if @options[:major]
    bumped_result[0] += 1
    bumped_result[1] = 0
    bumped_result[2] = 0
  else
    if @options[:minor]
      bumped_result[1] += 1
      bumped_result[2] = 0
    else
      if @options[:patch]
        bumped_result[2] += 1
      end
    end
  end
  bumped_version = bumped_result.join('.')
  puts "Bump version: #{result_array.join('.')} -> #{bumped_version}"
  bumped_version
end

def execute_line_if_not_dry_run(line)
  if @options[:dry_run]
    puts "Dry run:\n#{line}"
  else
    puts line
    value = %x[#{line}]
    puts value
    if $?.exitstatus != 0
      puts "Error (exit status = #{$?} -> exit"
      exit
    end
  end
end


def run_bumping_script

  check_repo_is_clean_or_dry_run
  result, result_array = find_version_in_podspec(find_spec_file)
  bumped_version = bump_version(result_array)

  unless @options[:dry_run]

    puts 'Are you sure? Click Y to continue:'
    str = gets.chomp
    if str != 'Y'
      puts '-> exit'
      exit
    end

  end

  execute_line_if_not_dry_run("sed -i \"\" \"s/#{result}/#{bumped_version}/\" README.md")
  execute_line_if_not_dry_run("sed -i \"\" \"s/#{result}/#{bumped_version}/\" ActionSheetPicker-3.0.podspec")
  execute_line_if_not_dry_run("git commit --all -m \"Update #{$SPEC_TYPE} to version #{bumped_version}\"")
  execute_line_if_not_dry_run("git tag #{bumped_version}")
  execute_line_if_not_dry_run('git push')
  execute_line_if_not_dry_run('git push --tags')
  execute_line_if_not_dry_run('pod trunk push ./ActionSheetPicker-3.0.podspec')

end

if __FILE__ == $0

  result, result_array = find_version_in_podspec(find_spec_file)
  
end
