# frozen_string_literal: true

require "delegate"
module GitHubChangelogGenerator
  # This class wraps Options, and knows a list of known options. Others options
  # will raise exceptions.
  class Options < SimpleDelegator
    # Raised on intializing with unknown keys in the values hash,
    # and when trying to store a value on an unknown key.
    UnsupportedOptionError = Class.new(ArgumentError)

    # List of valid option names
    KNOWN_OPTIONS = %i[
      add_issues_wo_labels
      add_pr_wo_labels
      author
      base
      between_tags
      bug_labels
      bug_prefix
      cache_file
      cache_log
      compare_link
      date_format
      due_tag
      enhancement_labels
      enhancement_prefix
      breaking_labels
      breaking_prefix
      exclude_labels
      exclude_tags
      exclude_tags_regex
      filter_issues_by_milestone
      frontmatter
      future_release
      github_endpoint
      github_site
      header
      http_cache
      include_labels
      issue_prefix
      issue_line_labels
      issues
      max_issues
      merge_prefix
      output
      project
      pulls
      release_branch
      release_url
      require
      simple_list
      since_tag
      ssl_ca_file
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

    private

    def values
      __getobj__
    end

    def unsupported_options
      values.keys - KNOWN_OPTIONS
    end

    def supported_option?(key)
      KNOWN_OPTIONS.include?(key)
    end
  end
end
