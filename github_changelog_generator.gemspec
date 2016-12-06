# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "github_changelog_generator/version"

Gem::Specification.new do |spec|
  spec.name               = "github_changelog_generator"
  spec.version            = GitHubChangelogGenerator::VERSION
  spec.default_executable = "github_changelog_generator"

  spec.required_ruby_version = ">= 1.9.3"
  spec.authors = ["Petr Korolev", "Olle Jonsson"]
  spec.email = "sky4winder+github_changelog_generator@gmail.com"

  spec.summary = "Script, that automatically generate changelog from your tags, issues, labels and pull requests."
  spec.description = "Changelog generation has never been so easy. Fully automate changelog generation - this gem generate change log file based on tags, issues and merged pull requests from Github issue tracker."
  spec.homepage = "https://github.com/skywinder/Github-Changelog-Generator"
  spec.license = "MIT"

  spec.files = Dir["{bin,lib,man,spec}/**/*"] + %w(LICENSE Rakefile README.md)

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rake", ">= 10.0"
  spec.add_runtime_dependency "rainbow", ">= 2.1"
  spec.add_runtime_dependency("octokit", ["~> 4.6"])
  spec.add_runtime_dependency("faraday-http-cache")
  spec.add_runtime_dependency("activesupport")
  spec.add_runtime_dependency("retriable", [">= 1.4"])
  spec.add_runtime_dependency("multi_json")
end
