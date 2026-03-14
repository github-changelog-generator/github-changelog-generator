# frozen_string_literal: true

require "open3"
require "uri"

module GitHubChangelogGenerator
  class GitRemote
    class << self
      def user_and_project
        remote_urls.each do |url|
          pair = extract_user_and_project(url)
          return pair if pair
        end

        nil
      end

      private

      # Returns remote URLs sorted so that "origin" comes first.
      def remote_urls
        stdout, status = Open3.capture2("git", "config", "--get-regexp", "^remote\\..*\\.url$")
        return [] unless status.success?

        remote_lines = stdout.each_line.map { |line| parse_remote_line(line) }

        remote_lines.compact
                    .sort_by { |name, _url| name == "origin" ? 0 : 1 }
                    .map(&:last)
      rescue Errno::ENOENT
        []
      end

      # Parses a git-config line like "remote.origin.url git@host:path".
      # The greedy (.+) correctly handles remote names containing dots (e.g. "my.fork").
      def parse_remote_line(line)
        config_key, remote_url = line.strip.split(/\s+/, 2)
        return if config_key.nil? || remote_url.nil?

        remote_name = config_key[%r{\Aremote\.(.+)\.url\z}, 1]
        return if remote_name.nil?

        [remote_name, remote_url]
      end

      def extract_user_and_project(url)
        extract_from_scp_url(url) || extract_from_uri(url)
      end

      def extract_from_scp_url(url)
        match = url.match(/\A[^@\/\s]+@[^:\/\s]+:(?<path>.+)\z/)
        return unless match

        extract_from_path(match[:path])
      end

      def extract_from_uri(url)
        uri = URI.parse(url)
        return if uri.host.nil? || uri.path.nil?

        extract_from_path(uri.path)
      rescue URI::InvalidURIError
        nil
      end

      # Extracts the last two path segments as user/project.
      # Handles standard "owner/repo" as well as deeper paths (e.g. GHE with path prefixes).
      def extract_from_path(path)
        normalized_path = path.sub(%r{\A/+}, "")
                              .delete_suffix("/")
                              .delete_suffix(".git")
        segments = normalized_path.split("/")
        return if segments.length < 2

        {
          user: segments[-2],
          project: segments[-1]
        }
      end
    end
  end
end
