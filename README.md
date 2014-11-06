Github Changelog Generator
==================

This script automatically generate change-log from your tags and merged pull-requests.

		Usage: github_changelog_generator.rb -u user_name -p project_name [-t 16-digit-GitHubToken] [options]
		    -u, --user [USER]                your username on GitHub
		    -p, --project [PROJECT]          name of project on GitHub
		    -t, --token [TOKEN]              To make more than 50 requests this app required your OAuth token for GitHub. You can generate it on https://github.com/settings/applications
		    -h, --help                       Displays Help
		    -v, --[no-]verbose               Run verbosely
		    -l, --last-changes               generate log between last 2 tags
		    -f, --date-format [FORMAT]       date format. default is %d/%m/%y 

### Example:
`github_changelog_generator.rb -u your-username -p your-project [-t 16-digit-GitHub-token-for-more-than-50-requests]`

In output you get `[your_project]_changelog.md` file with automatically generated changelogs.


## License

Github Changelog Generator is released under the [MIT License](http://www.opensource.org/licenses/MIT).