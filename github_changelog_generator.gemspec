Gem::Specification.new do |s|
  s.name               = "github_changelog_generator"
  s.version            = "1.1.2"
  s.default_executable = "github_changelog_generator"

  s.required_ruby_version     = '>= 1.9.3'
  s.authors = ["Petr Korolev"]
  s.date = `date +"%Y-%m-%d"`.strip!
  s.description = %q{Script, that automatically generate change-log from your tags and pull-requests}
  s.email = %q{sky4winder+github_changelog_generator@gmail.com}
  s.files = ["lib/github_changelog_generator.rb", "lib/github_changelog_generator/parser.rb", "bin/github_changelog_generator"]
  s.homepage = %q{https://github.com/skywinder/Github-Changelog-Generator}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Script, that automatically generate change-log from your tags and pull-requests.}
  s.license       = "MIT"
  s.add_runtime_dependency(%q<httparty>, ["~> 0.13"])
  s.add_runtime_dependency(%q<github_api>, ["~> 0.12"])
  s.add_runtime_dependency(%q<colorize>, ["~> 0.7"])

  s.executables   = %w(github_changelog_generator)
end
