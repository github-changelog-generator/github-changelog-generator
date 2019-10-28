# How to contribute

Bug reports and pull requests from users are what keep this project working.

## Basics

1. Create an issue and describe your idea
2. [Fork it](https://github.com/github-changelog-generator/github-changelog-generator/fork)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Publish the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## Checking your work

You can test your workflow with changelog generator with
[the github-changelog-generator/changelog_test repo].

You can run the test suite.

You can run [RuboCop] to check code style.

The default Rake task, runnable using `rake`, calls `rubocop`, then `spec`.

[the github-changelog-generator/changelog_test repo]: https://github.com/github-changelog-generator/changelog_test/
[RuboCop]: http://rubocop.readthedocs.io/en/latest/

## Write documentation

This project has documentation in a few places:

### Introduction and usage

A friendly `README.md` written for many audiences.

### Examples and advanced usage

The [wiki].

### API documentation

API documentation is written as [YARD] docblocks in the Ruby code.

This is rendered as Web pages on [Rubydoc.info][github-changelog-generator on Rubydoc.info].

The completeness of the API documentation is measured on [our page on the Inch CI website][github-changelog-generator on Inch CI].

### man page

`man/git-generate-changelog.md`

The man page is for the `git generate-changelog` Git sub-command, which is a wrapper for `github_changelog_generator`. That file is a Markdown file.

Use the [ronn] gem to generate `.1` and `.html` artifacts like this: `cd man; ronn git-generate-changelog.md`

[wiki]: https://github.com/github-changelog-generator/github-changelog-generator/wiki
[YARD]: https://yardoc.org/
[github-changelog-generator on Rubydoc.info]: http://www.rubydoc.info/gems/github_changelog_generator
[ronn]: https://github.com/rtomayko/ronn
[github-changelog-generator on Inch CI]: https://inch-ci.org/github/github-changelog-generator/github-changelog-generator

## Releasing a new version

1. Clone the repository
1. Install the dependencies (look at the CI configuration for the most updated procedure)
1. Update the changelog (and commit it afterwards): `github_changelog_generator -t <YOUR_GH_TOKEN> --future-release <FUTURE_RELEASE>`
1. Update the certification authority: `bundle exec rake update_ssl_ca_file`
1. Push the changes and wait for the latest CI build to complete
1. Bump the version, create a Git tag and commit the changes: `bundle exec bump pre --tag`
1. Push the version bump commit: `git push`
1. Push the Git tag: `git push --tags`
1. Build the new gem: `bundle exec rake build`
1. Push the new gem: `bundle exec rake release`

If you get the `Your rubygems.org credentials aren't set` error, set your RubyGems.org credentials:

```shell
curl -u your-rubygems-username https://rubygems.org/api/v1/api_key.yaml > $HOME/.gem/credentials
```
