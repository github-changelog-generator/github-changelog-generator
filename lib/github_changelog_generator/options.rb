# frozen_string_literal: true

require "delegate"
require "github_changelog_generator/helper"

module GitHubChangelogGenerator
  # This class wraps Options, and knows a list of known options. Others options
  # will raise exceptions.
  class Options < SimpleDelegator
    # Raised on initializing with unknown keys in the values hash,
    # and when trying to store a value on an unknown key.
    UnsupportedOptionError = Class.new(ArgumentError)

    # List of valid option names
    KNOWN_OPTIONS = %i[
      add_issues_wo_labels
      add_pr_wo_labels
      add_sections
      author
      base
      between_tags
      breaking_labels
      breaking_prefix
      bug_labels
      bug_prefix
      cache_file
      cache_log
      config_file
      compare_link
      configure_sections
      date_format
      deprecated_labels
      deprecated_prefix
      due_tag
      enhancement_labels
      enhancement_prefix
      exclude_labels
      exclude_tags
      exclude_tags_regex
      filter_issues_by_milestone
      issues_of_open_milestones
      frontmatter
      future_release
      github_endpoint
      github_site
      header
      http_cache
      include_labels
      include_tags_regex
      issue_prefix
      issue_line_labels
      issue_line_body
      issues
      max_issues
      merge_prefix
      output
      project
      pulls
      release_branch
      release_url
      removed_labels
      removed_prefix
      require
      security_labels
      security_prefix
      simple_list
      since_tag
      since_commit
      ssl_ca_file
      summary_labels
      summary_prefix
      token
      unreleased
      unreleased_label
      unreleased_only
      user
      usernames_as_github_logins
      verbose
    ]

    # @param values [Hash]
    #
    # @raise [UnsupportedOptionError] if given values contain unknown options
    def initialize(values)
      super(values)
      unsupported_options.any? && raise(UnsupportedOptionError, unsupported_options.inspect)
    end

    # Set option key to val.
    #
    # @param key [Symbol]
    # @param val [Object]
    #
    # @raise [UnsupportedOptionError] when trying to set an unknown option
    def []=(key, val)
      supported_option?(key) || raise(UnsupportedOptionError, key.inspect)
      values[key] = val
    end

    # @return [Hash]
    def to_hash
      values
    end

    # Loads the configured Ruby files from the --require option.
    def load_custom_ruby_files
      self[:require].each { |f| require f }
    end

    # Pretty-prints a censored options hash, if :verbose.
    def print_options
      return unless self[:verbose]

      Helper.log.info "Using these options:"
      # For ruby 2.5.0+
      censored_values.each do |key, value|
        print(key.inspect, "=>", value.inspect)
        puts ""
      end
      puts ""
    end

    # Boolean method for whether the user is using configure_sections
    def configure_sections?
      !self[:configure_sections].nil? && !self[:configure_sections].empty?
    end

    # Boolean method for whether the user is using add_sections
    def add_sections?
      !self[:add_sections].nil? && !self[:add_sections].empty?
    end

    # @return [Boolean] whether write to `:output`
    def write_to_file?
      self[:output].present?
    end

    private

    def values
      __getobj__
    end

    # Returns a censored options hash.
    #
    # @return [Hash] The GitHub `:token` key is censored in the output.
    def censored_values
      values.clone.tap { |opts| opts[:token] = opts[:token].nil? ? "No token used" : "hidden value" }
    end

    def unsupported_options
      values.keys - KNOWN_OPTIONS
    end

    def supported_option?(key)
      KNOWN_OPTIONS.include?(key)
    end
  end
end
