git-generate-changelog(1) - Generate changelog from GitHub
================================

## SYNOPSIS

`git generate-changelog` [-h|--help] [-u|--user] [-p|--project]

## DESCRIPTION

Automatically generate changelog from your tags, issues, labels and pull requests on GitHub.

## OPTIONS

  -u, --user USER

  Username of the owner of target GitHub repo.

  -p, --project PROJECT

  Name of project on GitHub.

  -t, --token TOKEN

  To make more than 50 requests per hour your GitHub token is required. You can generate it at: https://github.com/settings/tokens/new

  -f, --date-format FORMAT

  Date format. Default is %Y-%m-%d.

  -o, --output NAME

  Output file. To print to STDOUT instead, use blank as path. Default is CHANGELOG.md.

  -b, --base NAME

  Optional base file to append generated changes to. Default is HISTORY.md.

  --summary-label LABEL

  Set up custom label for the release summary section. Default is "".

  --breaking-label LABEL

  Set up custom label for breaking changes section. Default is "**Breaking changes:**".

  --enhancement-label LABEL

  Set up custom label for enhancements section. Default is "**Implemented enhancements:**".

  --bugs-label LABEL

  Set up custom label for bug-fixes section. Default is "**Fixed bugs:**".

  --deprecated-label LABEL

  Set up custom label for deprecated section. Default is "**Deprecated:**".

  --removed-label LABEL

  Set up custom label for removed section. Default is "**Removed:**".

  --security-label LABEL

  Set up custom label for security section. Default is "**Security:**".

  --issues-label LABEL

  Set up custom label for closed-issues section. Default is "**Closed issues:**".

  --header-label LABEL

  Set up custom header label. Default is "# Changelog".

  --configure-sections HASH, STRING

  Define your own set of sections which overrides all default sections.

  --add-sections HASH, STRING

  Add new sections but keep the default sections.

  --front-matter JSON

  Add YAML front matter. Formatted as JSON because it's easier to add on the command line.

  --pr-label LABEL

  Set up custom label for pull requests section. Default is "**Merged pull requests:**".

  --[no-]issues

  Include closed issues in changelog. Default is true.

  --[no-]issues-wo-labels

  Include closed issues without labels in changelog. Default is true.

  --[no-]pr-wo-labels

  Include pull requests without labels in changelog. Default is true.

  --[no-]pull-requests

  Include pull-requests in changelog. Default is true.

  --[no-]filter-by-milestone

  Use milestone to detect when issue was resolved. Default is true.

  --[no-]issues-of-open-milestones

  Include issues of open milestones. Default is true.

  --[no-]author

  Add author of pull request at the end. Default is true.

  --usernames-as-github-logins

  Use GitHub tags instead of Markdown links for the author of an issue or pull-request.

  --unreleased-only

  Generate log from unreleased closed issues only.

  --[no-]unreleased

  Add to log unreleased closed issues. Default is true.

  --unreleased-label LABEL

  Set up custom label for unreleased closed issues section. Default is "**Unreleased:**".

  --[no-]compare-link

  Include compare link (Full Changelog) between older version and newer version. Default is true.

  --include-labels x,y,z

  Of the labeled issues, only include the ones with the specified labels.

  --exclude-labels x,y,z

  Issues with the specified labels will be excluded from changelog. Default is 'duplicate,question,invalid,wontfix'.

  --summary-labels x,y,z

  Issues with these labels will be added to a new section, called "Release Summary". The section display only body of issues. Default is 'Release summary,release-summary,Summary,summary'.

  --breaking-labels x,y,z

  Issues with these labels will be added to a new section, called "Breaking changes". Default is 'backwards-incompatible,breaking'.

  --enhancement-labels x,y,z

  Issues with the specified labels will be added to "Implemented enhancements" section. Default is 'enhancement,Enhancement'.

  --bug-labels x,y,z

  Issues with the specified labels will be added to "Fixed bugs" section. Default is 'bug,Bug'.

  --deprecated-labels x,y,z

  Issues with the specified labels will be added to a section called "Deprecated". Default is 'deprecated,Deprecated'.

  --removed-labels x,y,z

  Issues with the specified labels will be added to a section called "Removed". Default is 'removed,Removed'.

  --security-labels x,y,z

  Issues with the specified labels will be added to a section called "Security fixes". Default is 'security,Security'.

  --issue-line-labels x,y,z

  The specified labels will be shown in brackets next to each matching issue. Use "ALL" to show all labels. Default is [].

  --exclude-tags x,y,z

  Changelog will exclude specified tags.

  --exclude-tags-regex REGEX

  Apply a regular expression on tag names so that they can be excluded, for example: --exclude-tags-regex ".*\+\d{1,}".

  --since-tag x

  Changelog will start after specified tag.

  --due-tag x

  Changelog will end before specified tag.

  --since-commit x
  
  Fetch only commits after this time. eg. "2017-01-01 10:00:00"

  --max-issues NUMBER

  Maximum number of issues to fetch from GitHub. Default is unlimited.

  --release-url URL

  The URL to point to for release links, in printf format (with the tag as variable).

  --github-site URL

  The Enterprise GitHub site where your project is hosted.

  --github-api URL

  The enterprise endpoint to use for your GitHub API.

  --simple-list

  Create a simple list from issues and pull requests. Default is false.

  --future-release RELEASE-VERSION

  Put the unreleased changes in the specified release number.

  --release-branch RELEASE-BRANCH

  Limit pull requests to the release branch, such as master or release.

  --http-cache

  Use HTTP Cache to cache GitHub API requests (useful for large repos). Default is true.

  --[no-]cache-file CACHE-FILE

  Filename to use for cache. Default is github-changelog-http-cache in a temporary directory.

  --cache-log CACHE-LOG

  Filename to use for cache log. Default is github-changelog-logger.log in a temporary directory.

  --ssl-ca-file PATH

  Path to cacert.pem file. Default is a bundled lib/github_changelog_generator/ssl_certs/cacert.pem. Respects SSL_CA_PATH.

  --require file1.rb,file2.rb

  Paths to Ruby file(s) to require before generating changelog.

  --[no-]verbose

  Run verbosely. Default is true.

  -v, --version

  Print version number.

  -h, --help

  Displays Help.

## REBASED COMMITS

GitHub pull requests that have been merged whose merge commit SHA has been modified through rebasing, cherry picking, or some other method may be tracked via a special comment on GitHub. Git commit SHAs found in comments on pull requests matching the regular expression `/rebased commit: ([0-9a-f]{40})/i` will be used in place of the original merge SHA when being added to the changelog.

## EXAMPLES

## AUTHOR

Written by Petr Korolev sky4winder@gmail.com

## REPORTING BUGS

&lt;<https://github.com/github-changelog-generator/github-changelog-generator/issues>&gt;

## SEE ALSO

&lt;<https://github.com/github-changelog-generator/github-changelog-generator/>&gt;
