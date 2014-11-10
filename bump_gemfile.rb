#!/usr/bin/env ruby
require 'optparse'

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

def find_version_in_podspec
  readme = File.read('ActionSheetPicker-3.0.podspec')

  re = /(\d+)\.(\d+)\.(\d+)/m

  match_result = re.match(readme)

  unless match_result
    puts 'Not found any versions'
    exit
  end

  puts "Found version #{match_result[0]}"
  return match_result[0], match_result.captures
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

def execute_line(line)
  if @options[:dry_run]
    puts 'Dry run: ' + line
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


check_repo_is_clean_or_dry_run
result, result_array = find_version_in_podspec
bumped_version = bump_version(result_array)

unless @options[:dry_run]

  puts 'Are you sure? Click Y to continue:'
  str = gets.chomp
  if str != 'Y'
    puts '-> exit'
    exit
  end

end

execute_line("sed -i \"\" \"s/#{result}/#{bumped_version}/\" README.md")
execute_line("sed -i \"\" \"s/#{result}/#{bumped_version}/\" ActionSheetPicker-3.0.podspec")
execute_line("git commit --all -m \"Update podspec to version #{bumped_version}\"")
execute_line("git tag #{bumped_version}")
execute_line('git push')
execute_line('git push --tags')
execute_line('pod trunk push ./ActionSheetPicker-3.0.podspec')

