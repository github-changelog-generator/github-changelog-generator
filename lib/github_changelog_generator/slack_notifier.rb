module GitHubChangelogGenerator
  class SlackNotifier
    def self.ping(options, message)
      channel = options[:slack_channel] || "general"
      username = options[:slack_username] || "webhookbot"

      notifier = Slack::Notifier.new(
        options[:slack_webhook_url],
        channel: "##{channel}",
        username: username
      )

      notifier.ping slack_compatible(message)
    end

    def self.slack_compatible(message)
      message.gsub("&", "&amp;")
             .gsub("<", "&lt;").gsub(">", "&gt;")
             .gsub("**", "*").gsub("\\*", "")
    end
  end
end
