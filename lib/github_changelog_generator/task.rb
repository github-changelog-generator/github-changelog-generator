require "rake"
require "rake/tasklib"
require "github_changelog_generator"

module GitHubChangelogGenerator
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    OPTIONS = %w( user project token date_format output
                  bug_prefix enhancement_prefix issue_prefix
                  header merge_prefix issues
                  add_issues_wo_labels add_pr_wo_labels
                  pulls filter_issues_by_milestone author
                  unreleased_only unreleased unreleased_label
                  compare_link include_labels exclude_labels
                  bug_labels enhancement_labels
                  between_tags exclude_tags since_tag max_issues
                  github_site github_endpoint simple_list
                  future_release verbose release_url )

    OPTIONS.each do |o|
      attr_accessor o.to_sym
    end

    # Public: Initialise a new GitHubChangelogGenerator::RakeTask.
    #
    # Example
    #
    #   GitHubChangelogGenerator::RakeTask.new
    def initialize(*args, &task_block)
      @name = args.shift || :changelog

      define(args, &task_block)
    end

    def define(args, &task_block)
      desc "Generate a Change log from GitHub"

      task_block.call(*[self, args].slice(0, task_block.arity)) if task_block

      # clear any (auto-)pre-existing task
      Rake::Task[@name].clear if Rake::Task.task_defined?(@name)

      task @name do
        # mimick parse_options
        options = Parser.get_default_options

        if options[:user].nil? || options[:project].nil?
          Parser.detect_user_and_project(options)
        end

        OPTIONS.each do |o|
          v = instance_variable_get("@#{o}")
          options[o.to_sym] = v unless v.nil?
        end

        generator = Generator.new options

        log = generator.compound_changelog

        output_filename = "#{options[:output]}"
        File.open(output_filename, "w") { |file| file.write(log) }
        puts "Done!"
        puts "Generated log placed in #{Dir.pwd}/#{output_filename}"
      end
    end
  end
end
