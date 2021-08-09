[![Gem Version](https://badge.fury.io/rb/github_changelog_generator.svg)](http://badge.fury.io/rb/github_changelog_generator)
[![CircleCI](https://circleci.com/gh/github-changelog-generator/github-changelog-generator.svg?style=svg)](https://circleci.com/gh/github-changelog-generator/github-changelog-generator)
[![Inline docs](http://inch-ci.org/github/github-changelog-generator/github-changelog-generator.svg)](http://inch-ci.org/github/github-changelog-generator/github-changelog-generator)
[![Join the chat at https://gitter.im/github-changelog-generator/chat](https://badges.gitter.im/github-changelog-generator/chat.svg)](https://gitter.im/github-changelog-generator/chat?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# github-changelog-generator ![GitHub Logo](../master/images/logo.jpg)

<!--
To update TOC, please run:
> doctoc ./README.md --github
 -->
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


  - [Changelog generation has never been so easy](#changelog-generation-has-never-been-so-easy)
  - [*What’s the point of a changelog?*](#whats-the-point-of-a-changelog)
  - [*Why should I care?*](#why-should-i-care)
- [Installation](#installation)
- [Running with Docker](#running-with-docker)
- [Output example](#output-example)
- [Usage](#usage)
  - [Params](#params)
  - [Params File](#params-file)
  - [GitHub token](#github-token)
- [Migrating from a manual changelog](#migrating-from-a-manual-changelog)
  - [Rake task](#rake-task)
- [Features and advantages of this project](#features-and-advantages-of-this-project)
  - [Using the summary section feature](#using-the-summary-section-feature)
  - [Alternatives](#alternatives)
  - [Projects using this library](#projects-using-this-library)
- [Am I missing some essential feature?](#am-i-missing-some-essential-feature)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### Changelog generation has never been so easy

**Fully automated changelog generation** - This gem generates a changelog file based on **tags**, **issues** and merged **pull requests** (and splits them into separate lists according to labels) from :octocat: GitHub.

Since you don't have to fill your `CHANGELOG.md` manually now: just run the script, relax and take a cup of :coffee: before your next release! :tada:

### *What’s the point of a changelog?*

To make it easier for users and contributors to see precisely what notable changes have been made between each release (or version) of the project.

### *Why should I care?*

Because software tools are for _people_. "Changelogs make it easier for users and
contributors to see precisely what notable changes have been made between each
release (or version) of the project."

:arrow_right: *[https://keepachangelog.com](https://keepachangelog.com)*

## Installation

GitHub Changelog Generator is a [Ruby](https://www.ruby-lang.org/)
program, distributed as a RubyGem. The Ruby language homepage has an [Installation page](https://www.ruby-lang.org/en/documentation/installation/).

Install the gem like:

    $ gem install github_changelog_generator

Depending on your system, you _may_ need to run the shell as an Administrator (Windows),
or use `sudo gem install github_changelog_generator` (Linux).


## Usage


### Running with CLI:

	   github_changelog_generator -u github_project_namespace -p github_project

(where the project namespace is _likely_ your username if it's a project you own, but it could also be the namespace of the project)


### Running with Docker

Using [Docker](https://www.docker.com/products/docker-desktop) is an alternative to installing Ruby and the gem.

Example invocation:

    $ docker run -it --rm -v "$(pwd)":/usr/local/src/your-app githubchangeloggenerator/github-changelog-generator



- For GitHub Enterprise repos, specify *both* `--github-site` and `--github-api` options:

       $ github_changelog_generator --github-site="https://github.yoursite.com" \
                                  --github-api="https://github.yoursite.com/api/v3/"


This generates a `CHANGELOG.md`, with pretty Markdown formatting.


## Output example

- Look at **[CHANGELOG.md](https://github.com/github-changelog-generator/Github-Changelog-Generator/blob/master/CHANGELOG.md)** for this project
- [ActionSheetPicker-3.0/CHANGELOG.md](https://github.com/skywinder/ActionSheetPicker-3.0/blob/develop/CHANGELOG.md) was generated by command:

      $ github_changelog_generator -u github-changelog-generator -p ActionSheetPicker-3.0

- In general, it looks like this:

> ## [1.2.5](https://github.com/github-changelog-generator/Github-Changelog-Generator/tree/1.2.5) (2015-01-15)
>
> [Full Changelog](https://github.com/github-changelog-generator/Github-Changelog-Generator/compare/1.2.4...1.2.5)
>
> **Implemented enhancements:**
>
> - Use milestone to specify in which version bug was fixed [\#22](https://github.com/github-changelog-generator/Github-Changelog-Generator/issues/22)
>
> **Fixed bugs:**
>
> - Error when trying to generate log for repo without tags [\#32](https://github.com/github-changelog-generator/Github-Changelog-Generator/issues/32)
>
> **Merged pull requests:**
>
> - PrettyPrint class is included using lowercase 'pp' [\#43](https://github.com/github-changelog-generator/Github-Changelog-Generator/pull/43) ([schwing](https://github.com/schwing))
>
> - support enterprise github via command line options [\#42](https://github.com/github-changelog-generator/Github-Changelog-Generator/pull/42) ([glenlovett](https://github.com/glenlovett))

### Params

Print help for all command-line options to learn more details:

    $ github_changelog_generator --help

For more details about params, read the Wiki page: [**Advanced changelog generation examples**](https://github.com/github-changelog-generator/github-changelog-generator/wiki/Advanced-change-log-generation-examples)

### Params File

In your project root, you can put a params file named `.github_changelog_generator` to override default params:

Example:

```
unreleased=false
future-release=5.0.0
since-tag=1.0.0
```

### GitHub token

GitHub only allows **50 unauthenticated requests per hour**.

Therefore, it's recommended to run this script with authentication by using a **token**.

Here's how:

- [Generate a token here](https://github.com/settings/tokens/new?description=GitHub%20Changelog%20Generator%20token) - you only need "repo" scope for private repositories
- Either:
    - Run the script with `--token <your-40-digit-token>`; **OR**
    - Set the `CHANGELOG_GITHUB_TOKEN` environment variable to your 40 digit token

You can set an environment variable by running the following command at the prompt, or by adding it to your shell profile (e.g., `.env`, `~/.bash_profile`, `~/.zshrc`, etc):

    export CHANGELOG_GITHUB_TOKEN="«your-40-digit-github-token»"

So, if you get a message like this:

``` markdown
API rate limit exceeded for github_username.
See: https://developer.github.com/v3/#rate-limiting
```

It's time to create this token! (Or, wait an hour for GitHub to reset your unauthenticated request limit.)

## Migrating from a manual changelog

Knowing how dedicated you are to your project, you probably haven't been waiting for `github-changelog-generator` to keep a changelog.
But you probably don't want your project's open issues and PRs for all past features listed in your historic changelog, either.

That's where `--base <your-manual-changelog.md>` comes in handy!
This option lets append your old manual changelog to the end of the generated entries.

If you have a `HISTORY.md` file in your project, it will automatically be picked as the static historical changelog and appended.

### Rake task

You love `rake`? We do, too! So, we've made it even easier for you:
we've provided a `rake` task library for your changelog generation.

Configure the task in your `Rakefile`:

```ruby
require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'username'
  config.project = 'project-name'
  config.since_tag = '0.1.14'
  config.future_release = '0.2.0'
end
```

All command-line options can be passed to the `rake` task as `config`
parameters. And since you're naming the `rake` task yourself, you can create
as many as you want.

You can look for params names from the [parser source code (#setup_parser)](https://github.com/github-changelog-generator/github-changelog-generator/blob/master/lib/github_changelog_generator/parser.rb). For example, to translate the bugs label to Portuguese, instead of setting `config.bugs_label`, you have to set `config.bug_prefix`, and so on.

## Features and advantages of this project

- Generate canonical, neat changelog file, with default sections that follow [basic changelog guidelines](http://keepachangelog.com) :gem:
- Optionally generate **Unreleased** changes (closed issues that have not released yet) :dizzy:
- **GitHub Enterprise support** via command line options! :factory:
- Flexible format **customization**:
    - **Customize** issues that **should be added** to changelog :eight_spoked_asterisk:
    - **Custom date formats** supported (but keep [ISO 8601](http://xkcd.com/1179/) in mind!) :date:
    - Manually specify the version that fixed an issue (for cases when the issue's Closed date doesn't match) by giving the issue's `milestone` the same name as the tag of version :pushpin:
    - Automatically **exclude specific issues** that are irrelevant to your changelog (by default, any issue labeled `question`, `duplicate`, `invalid`, or `wontfix`) :scissors:
- **Distinguish** issues **by labels**. :mag_right:
    - Merged pull requests (all merged pull-requests) :twisted_rightwards_arrows:
    - Bug fixes (issues labeled `bug`) :beetle:
    - Enhancements (issues labeled `enhancement`) :star2:
    - Issues (closed issues with no labels) :non-potable_water:

- Manually include or exclude issues by labels :wrench:
- Customize lots more! Tweak the changelog to fit your preferences :tophat:
(*See `github_changelog_generator --help`  for details)*

### Using the summary section feature

For each version, you can add a _release summary_ with text, images, gif animations,
etc, and show new features and notes clearly to the user. This is done using GitHub metadata.

**Example**: adding the release summary for v1.0.0:

1. Create a new GitHub Issue
2. In the Issue's _Description_ field, add your release summary content
```
![image](https://user-images.githubusercontent.com/12690315/45935880-006a8200-bfeb-11e8-958e-ff742ae66b96.png)

Hello, World! :tada:
```
3. Set the Issue Label `release-summary` and add it to the GitHub Milestone `v1.0.0`
4. Close the Issue and execute `github-changelog-generator`
5. The result looks like this:
> ## [v1.0.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.0.0) (2014-11-07)
> [Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/0.1.0...1.0.0)
>
> ![image](https://user-images.githubusercontent.com/12690315/45935880-006a8200-bfeb-11e8-958e-ff742ae66b96.png)
>
> Hello, World! :tada:
>
> **Implemented enhancements:**
> - Add some features

### Alternatives

Here is a [wikipage list of alternatives](https://github.com/github-changelog-generator/Github-Changelog-Generator/wiki/Alternatives) that I found. But none satisfied my requirements.

*If you know other projects, feel free to edit this Wiki page!*


### Projects using this library

Here's a [wikipage list of projects](https://github.com/github-changelog-generator/Github-Changelog-Generator/wiki/Projects-using-Github-Changelog-Generator).

If you've used this project in a live app, please let me know! Nothing makes me happier than seeing someone else take my work and go wild with it.

*If you are using `github_changelog_generator` to generate your project's changelog, or know of other projects using it, please [add it to this list](https://github.com/github-changelog-generator/github-changelog-generator/wiki/Projects-using-Github-Changelog-Generator).*

## Am I missing some essential feature?

- **Nothing is impossible!**

- Open an [issue](https://github.com/github-changelog-generator/Github-Changelog-Generator/issues/new/choose) and let's make the generator better together!

- *Bug reports, feature requests, patches, and well-wishes are always welcome.* :heavy_exclamation_mark:

## FAQ

- ***I already use GitHub Releases. Why do I need this?***

GitHub Releases is a very good thing. And it's very good practice to maintain it. (Not a lot of people are using it yet!) :congratulations:

*BTW: I would like to support GitHub Releases in [next releases](https://github.com/github-changelog-generator/github-changelog-generator/issues/56) ;)*

I'm not trying to compare the quality of handwritten and auto-generated logs. That said....

An auto-generated changelog really helps, even if you manually fill in the release notes!


- ***My Ruby version is very old, can I use this?***

When your Ruby is old, and you don't want to upgrade, and you want to
control which libraries you use, you can use Bundler.

In a Gemfile, perhaps in a non-deployed `:development` group, add this
gem:

```ruby
group :development do
  gem 'github_changelog_generator', require: false
end
```

Then you can keep back dependencies like rack, which currently is only
compatible with Ruby >= 2.2.2. So, use an older version for your app by
adding a line like this to the Gemfile:

```
gem 'rack', '~> 1.6'
```

This way, you can keep on using github_changelog_generator, even if you
can't get the latest version of Ruby installed.

- ***Windows: 1.14.x wants to create a file on an invalid path. Why?***

Windows: [v1.14.0 introduced a bug where it attempts to create /tmp/github_changelog-logger.log... which isn't a valid path on Windows and thus fails](https://github.com/github-changelog-generator/github-changelog-generator/issues/458)

Workaround: Create a `C:\tmp`.

## Contributing

Would you like to contribute to this project? [CONTRIBUTING.md] has all the details on how to do that.

[CONTRIBUTING.md]: CONTRIBUTING.md

## Contact us
[Join the chat at gitter : github-changelog-generator](https://gitter.im/github-changelog-generator/chat?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## License

GitHub Changelog Generator is released under the [MIT License](http://www.opensource.org/licenses/MIT).
