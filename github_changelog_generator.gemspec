# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_changelog_generator/version'

Gem::Specification.new do |spec|
  spec.name               = "github_changelog_generator"
  spec.version            = GitHubChangelogGenerator::VERSION
  spec.default_executable = "github_changelog_generator"

  spec.required_ruby_version     = '>= 1.9.3'
  spec.authors = ["Petr Korolev"]
  spec.email = %q{sky4winder+github_changelog_generator@gmail.com}
  spec.date = `date +"%Y-%m-%d"`.strip!
  spec.summary = %q{Script, that automatically generate change-log from your tags and pull-requests.}
  spec.description = %q{Script, that automatically generate change-log from your tags and pull-requests}
  spec.homepage = %q{https://github.com/skywinder/Github-Changelog-Generator}
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency(%q<github_api>, ["~> 0.12"])
  spec.add_runtime_dependency(%q<colorize>, ["~> 0.7"])

end
