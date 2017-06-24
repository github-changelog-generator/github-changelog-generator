# frozen_string_literal: true

require "delegate"
module GitHubChangelogGenerator
  class Options < SimpleDelegator
    UnsupportedOptionError = Class.new(ArgumentError)

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
      git_remote
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

    def initialize(values)
      super(values)
      unsupported_options.any? && raise(UnsupportedOptionError, unsupported_options.inspect)
    end

    def []=(key, val)
      supported_option?(key) || raise(UnsupportedOptionError, key.inspect)
      values[key] = val
    end

    def to_hash
      values
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
