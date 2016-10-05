# frozen_string_literal: true
require 'delegate'
module GitHubChangelogGenerator
  class Options < SimpleDelegator
    KNOWN_OPTIONS = [
      :add_issues_wo_labels,
      :add_pr_wo_labels,
      :author,
      :base,
      :between_tags,
      :bug_labels,
      :bug_prefix,
      :cache_file,
      :cache_log,
      :compare_link,
      :date_format,
      :due_tag,
      :enhancement_labels,
      :enhancement_prefix,
      :exclude_labels,
      :exclude_tags,
      :exclude_tags_regex,
      :filter_issues_by_milestone,
      :frontmatter,
      :future_release,
      :git_remote,
      :github_endpoint,
      :github_site,
      :header,
      :http_cache,
      :include_labels,
      :issue_prefix,
      :issues,
      :max_issues,
      :merge_prefix,
      :output,
      :project,
      :pulls,
      :release_branch,
      :release_url,
      :simple_list,
      :since_tag,
      :token,
      :unreleased,
      :unreleased_label,
      :unreleased_only,
      :user,
      :usernames_as_github_logins,
      :verbose,
    ]

    THESE_ARE_DIFFERENT = [
      :tag1,
      :tag2,
    ]

    def initialize(values)
      super(values)
      if unsupported_options.any?
        raise ArgumentError, "Unsupported options #{unsupported_options}"
      end
    end

    def to_hash
      values
    end

    private

    def values
      __getobj__
    end

    def unsupported_options
      values.keys - (KNOWN_OPTIONS + THESE_ARE_DIFFERENT)
    end
  end
end
