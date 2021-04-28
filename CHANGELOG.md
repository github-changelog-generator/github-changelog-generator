# Changelog

## [1.16.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.16.2) (2021-04-28)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.16.1...1.16.2)

**Implemented enhancements:**

- Configure a Docker Automated build [\#644](https://github.com/github-changelog-generator/github-changelog-generator/issues/644)

**Fixed bugs:**

- Getting an error: ` 'list_issues': wrong number of arguments (given 3, expected 0..2) (ArgumentError)` [\#952](https://github.com/github-changelog-generator/github-changelog-generator/issues/952)

**Closed issues:**

- Error generating change log using \>=1.16.0 [\#956](https://github.com/github-changelog-generator/github-changelog-generator/issues/956)
- Unable to run, undefined method `include?' for nil:NilClass \(NoMethodError\) [\#954](https://github.com/github-changelog-generator/github-changelog-generator/issues/954)
- Docker images are not published for new releases [\#951](https://github.com/github-changelog-generator/github-changelog-generator/issues/951)
- Not all options listed in OptionParser have optional arguments [\#945](https://github.com/github-changelog-generator/github-changelog-generator/issues/945)
- Add Ruby 3 to CI, make it pass [\#928](https://github.com/github-changelog-generator/github-changelog-generator/issues/928)
- SSL error on Windows with docker [\#894](https://github.com/github-changelog-generator/github-changelog-generator/issues/894)

**Merged pull requests:**

- Fix: always return an Array from \#commits\_in\_branch [\#957](https://github.com/github-changelog-generator/github-changelog-generator/pull/957) ([olleolleolle](https://github.com/olleolleolle))
- Use the githubchangeloggenerator Docker Hub org [\#955](https://github.com/github-changelog-generator/github-changelog-generator/pull/955) ([ferrarimarco](https://github.com/ferrarimarco))
- Support Ruby 3 [\#949](https://github.com/github-changelog-generator/github-changelog-generator/pull/949) ([magneland](https://github.com/magneland))
- Update help output to reflect required args. [\#946](https://github.com/github-changelog-generator/github-changelog-generator/pull/946) ([spark-c](https://github.com/spark-c))
- Add --config-file command line parameter [\#917](https://github.com/github-changelog-generator/github-changelog-generator/pull/917) ([anakinj](https://github.com/anakinj))

## [v1.16.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.16.1) (2021-03-22)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.16.0...v1.16.1)

**Fixed bugs:**

- Release 1.16: If you give a specifc name to the GitHubChangelogGenerator::RakeTask, it breaks. [\#942](https://github.com/github-changelog-generator/github-changelog-generator/issues/942)

**Merged pull requests:**

- Release 1.16.1 [\#944](https://github.com/github-changelog-generator/github-changelog-generator/pull/944) ([olleolleolle](https://github.com/olleolleolle))
- Rake Task: avoid calling super with arguments to avoid an ArgumentError [\#943](https://github.com/github-changelog-generator/github-changelog-generator/pull/943) ([olleolleolle](https://github.com/olleolleolle))

## [v1.16.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.16.0) (2021-03-21)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.15.2...v1.16.0)

**Implemented enhancements:**

- Enabling branch protection for the master branch [\#793](https://github.com/github-changelog-generator/github-changelog-generator/issues/793)
- Add no-http-cache option to rake task [\#739](https://github.com/github-changelog-generator/github-changelog-generator/pull/739) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- Footer message that keeps replicating [\#787](https://github.com/github-changelog-generator/github-changelog-generator/issues/787)
- `Octokit::NotFound' error happens since 372875f7  [\#695](https://github.com/github-changelog-generator/github-changelog-generator/issues/695)
- Fix not parsing body\_only param for sections [\#755](https://github.com/github-changelog-generator/github-changelog-generator/pull/755) ([dusan-dragon](https://github.com/dusan-dragon))
- Bugfix: undefined method line\_labels\_for [\#753](https://github.com/github-changelog-generator/github-changelog-generator/pull/753) ([dusan-dragon](https://github.com/dusan-dragon))

**Closed issues:**

- Can't install it. [\#933](https://github.com/github-changelog-generator/github-changelog-generator/issues/933)
- pip install docker [\#924](https://github.com/github-changelog-generator/github-changelog-generator/issues/924)
- configure\_sections needs better examples [\#923](https://github.com/github-changelog-generator/github-changelog-generator/issues/923)
- Add PR that are not linked to an issue [\#890](https://github.com/github-changelog-generator/github-changelog-generator/issues/890)
- the `-u` parameter in the readme is a bit misleading [\#877](https://github.com/github-changelog-generator/github-changelog-generator/issues/877)
- presets/node.js [\#867](https://github.com/github-changelog-generator/github-changelog-generator/issues/867)
- "Full Changelog" uses tags that are excluded [\#842](https://github.com/github-changelog-generator/github-changelog-generator/issues/842)
- Failure with `stack level too deep` [\#829](https://github.com/github-changelog-generator/github-changelog-generator/issues/829)
- Get rid of multi\_json [\#789](https://github.com/github-changelog-generator/github-changelog-generator/issues/789)
- Nondeterministic moving/deleting of PRs in CHANGELOG.md [\#774](https://github.com/github-changelog-generator/github-changelog-generator/issues/774)
- Special characters inside `inline_code` incorrectly escaped [\#742](https://github.com/github-changelog-generator/github-changelog-generator/issues/742)
- Milestones on PRs not taken into account [\#457](https://github.com/github-changelog-generator/github-changelog-generator/issues/457)

**Merged pull requests:**

- Restoring tag hash references to string keys [\#937](https://github.com/github-changelog-generator/github-changelog-generator/pull/937) ([douglasmiller](https://github.com/douglasmiller))
- Fixing 'stack level too deep error' in commits\_in\_tag [\#936](https://github.com/github-changelog-generator/github-changelog-generator/pull/936) ([douglasmiller](https://github.com/douglasmiller))
- When tags are excluded, do not include those tags in diff links. [\#930](https://github.com/github-changelog-generator/github-changelog-generator/pull/930) ([ameir](https://github.com/ameir))
- Add --include-tags-regex option. [\#929](https://github.com/github-changelog-generator/github-changelog-generator/pull/929) ([ameir](https://github.com/ameir))
- Use UTC for future release date [\#926](https://github.com/github-changelog-generator/github-changelog-generator/pull/926) ([smortex](https://github.com/smortex))
- Update issue templates [\#922](https://github.com/github-changelog-generator/github-changelog-generator/pull/922) ([skywinder](https://github.com/skywinder))
- More concurrency [\#921](https://github.com/github-changelog-generator/github-changelog-generator/pull/921) ([ioquatix](https://github.com/ioquatix))
- updated the readme and the parser help message [\#878](https://github.com/github-changelog-generator/github-changelog-generator/pull/878) ([dmarticus](https://github.com/dmarticus))
- \(chore\) Fix Performance/StartWith [\#851](https://github.com/github-changelog-generator/github-changelog-generator/pull/851) ([olleolleolle](https://github.com/olleolleolle))
- add since-commit option [\#830](https://github.com/github-changelog-generator/github-changelog-generator/pull/830) ([takke](https://github.com/takke))
- add option --\[no-\]issues-of-open-milestones [\#801](https://github.com/github-changelog-generator/github-changelog-generator/pull/801) ([Mairu](https://github.com/Mairu))
- Don't escape special chars when they are in `inline_code` \(carried from \#743\) [\#797](https://github.com/github-changelog-generator/github-changelog-generator/pull/797) ([olleolleolle](https://github.com/olleolleolle))
- Fix replicating template messages [\#794](https://github.com/github-changelog-generator/github-changelog-generator/pull/794) ([shinyaohtani](https://github.com/shinyaohtani))
- Tell the truth in this comment [\#792](https://github.com/github-changelog-generator/github-changelog-generator/pull/792) ([olleolleolle](https://github.com/olleolleolle))
- Section: Split quicker on newline [\#791](https://github.com/github-changelog-generator/github-changelog-generator/pull/791) ([olleolleolle](https://github.com/olleolleolle))
- \(refactor\) Reuse an Entry instance in Section; change accessors to readers [\#790](https://github.com/github-changelog-generator/github-changelog-generator/pull/790) ([olleolleolle](https://github.com/olleolleolle))
- Drop support for EOL Ruby versions [\#786](https://github.com/github-changelog-generator/github-changelog-generator/pull/786) ([olleolleolle](https://github.com/olleolleolle))
- Use `async-http-faraday`. [\#784](https://github.com/github-changelog-generator/github-changelog-generator/pull/784) ([ioquatix](https://github.com/ioquatix))
- CI: Ruby 2.3, Ruby 2.4 hold at ActiveSupport \< 6 [\#782](https://github.com/github-changelog-generator/github-changelog-generator/pull/782) ([olleolleolle](https://github.com/olleolleolle))
- CI: JRuby 9.1 support: hold ActiveSupport at 5.x, introduce gemfiles/ directory [\#780](https://github.com/github-changelog-generator/github-changelog-generator/pull/780) ([olleolleolle](https://github.com/olleolleolle))
- Fixing bug when filtering pull requests without labels [\#771](https://github.com/github-changelog-generator/github-changelog-generator/pull/771) ([douglasmiller](https://github.com/douglasmiller))

## [v1.15.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.15.2) (2020-04-07)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.15.1...v1.15.2)

**Merged pull requests:**

- Put back bin files [\#779](https://github.com/github-changelog-generator/github-changelog-generator/pull/779) ([skywinder](https://github.com/skywinder))

## [v1.15.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.15.1) (2020-04-05)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.15.0...v1.15.1)

**Implemented enhancements:**

- Releasing 1.15.0 [\#728](https://github.com/github-changelog-generator/github-changelog-generator/issues/728)
- Partial updates / add missing versions [\#209](https://github.com/github-changelog-generator/github-changelog-generator/issues/209)
- Minor grammar fix [\#765](https://github.com/github-changelog-generator/github-changelog-generator/pull/765) ([cachedout](https://github.com/cachedout))

**Closed issues:**

- Warning about Project\_card\_events API [\#773](https://github.com/github-changelog-generator/github-changelog-generator/issues/773)
- To improve build\_url method in Locust HttpSession [\#744](https://github.com/github-changelog-generator/github-changelog-generator/issues/744)
- uninitialized constant Faraday::Error::ClientError \(NameError\) [\#741](https://github.com/github-changelog-generator/github-changelog-generator/issues/741)
- TypeError: no implicit conversion of nil into Array [\#738](https://github.com/github-changelog-generator/github-changelog-generator/issues/738)
- bundler 1.14.3 issue with  uninitalized constant [\#474](https://github.com/github-changelog-generator/github-changelog-generator/issues/474)

**Merged pull requests:**

- fix: disable preview api warning from octokit.rb [\#777](https://github.com/github-changelog-generator/github-changelog-generator/pull/777) ([digglife](https://github.com/digglife))

## [v1.15.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.15.0) (2019-10-05)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.15.0.pre.rc...v1.15.0)

**Implemented enhancements:**

- CircleCI: Add a build matrix [\#685](https://github.com/github-changelog-generator/github-changelog-generator/issues/685)
- A way to add release summaries [\#582](https://github.com/github-changelog-generator/github-changelog-generator/issues/582)
- CI: Use the shorter image names for less maint [\#716](https://github.com/github-changelog-generator/github-changelog-generator/pull/716) ([olleolleolle](https://github.com/olleolleolle))
- Build matrix for different ruby & jruby versions [\#686](https://github.com/github-changelog-generator/github-changelog-generator/pull/686) ([szemek](https://github.com/szemek))
- CircleCI 2.0 configuration [\#684](https://github.com/github-changelog-generator/github-changelog-generator/pull/684) ([szemek](https://github.com/szemek))
- 588 : Added new line after credits [\#627](https://github.com/github-changelog-generator/github-changelog-generator/pull/627) ([qwerty2323](https://github.com/qwerty2323))
- Support printing changelog to stdout [\#624](https://github.com/github-changelog-generator/github-changelog-generator/pull/624) ([sue445](https://github.com/sue445))
- Fix unlabeled, mixed labels, and unmapped labels handling [\#618](https://github.com/github-changelog-generator/github-changelog-generator/pull/618) ([hunner](https://github.com/hunner))
- Implemented a Dockerfile [\#592](https://github.com/github-changelog-generator/github-changelog-generator/pull/592) ([ferrarimarco](https://github.com/ferrarimarco))
- Make 'change log' a single word [\#579](https://github.com/github-changelog-generator/github-changelog-generator/pull/579) ([mesaugat](https://github.com/mesaugat))

**Fixed bugs:**

- Add a new line after the credits [\#588](https://github.com/github-changelog-generator/github-changelog-generator/issues/588)
- can't create Thread: Not enough space \(ThreadError\) [\#402](https://github.com/github-changelog-generator/github-changelog-generator/issues/402)
- Fix warnings in ruby 2.6 [\#701](https://github.com/github-changelog-generator/github-changelog-generator/pull/701) ([mhenrixon](https://github.com/mhenrixon))
- Remove threading and use caching [\#653](https://github.com/github-changelog-generator/github-changelog-generator/pull/653) ([hunner](https://github.com/hunner))
- Use git history to find PRs in a tag instead of time [\#619](https://github.com/github-changelog-generator/github-changelog-generator/pull/619) ([hunner](https://github.com/hunner))

**Closed issues:**

- Gitea integration  [\#735](https://github.com/github-changelog-generator/github-changelog-generator/issues/735)
- Could we publish the latest version to gem? [\#722](https://github.com/github-changelog-generator/github-changelog-generator/issues/722)
- docker container waits for a long time, then crashes [\#717](https://github.com/github-changelog-generator/github-changelog-generator/issues/717)
- N/A [\#713](https://github.com/github-changelog-generator/github-changelog-generator/issues/713)
- Example Rakefile [\#712](https://github.com/github-changelog-generator/github-changelog-generator/issues/712)
- Cannot generate the changelog for a repo moved from BitBucket to GitHub [\#699](https://github.com/github-changelog-generator/github-changelog-generator/issues/699)
- End support of Ruby 2.2 [\#687](https://github.com/github-changelog-generator/github-changelog-generator/issues/687)
- \[ci\] Configure a CircleCI 2.0 configuration [\#681](https://github.com/github-changelog-generator/github-changelog-generator/issues/681)
- \[DOC\] Explain new Labels and Summary Section support in README [\#678](https://github.com/github-changelog-generator/github-changelog-generator/issues/678)
- Encore! [\#669](https://github.com/github-changelog-generator/github-changelog-generator/issues/669)
- Hang on pretty print of options in 1.15.0-rc [\#668](https://github.com/github-changelog-generator/github-changelog-generator/issues/668)
- Latest docker image hanging [\#663](https://github.com/github-changelog-generator/github-changelog-generator/issues/663)
- More instructions on how to use it with docker [\#652](https://github.com/github-changelog-generator/github-changelog-generator/issues/652)
- process stucks/hangs and the memory usage increases up to 4.6Gib [\#651](https://github.com/github-changelog-generator/github-changelog-generator/issues/651)
- couldn't generate changelog for organization repos [\#647](https://github.com/github-changelog-generator/github-changelog-generator/issues/647)
- Closed issues reported under the wrong milestone [\#638](https://github.com/github-changelog-generator/github-changelog-generator/issues/638)
- Updating to v1.15.0-rc requires --user and --project [\#633](https://github.com/github-changelog-generator/github-changelog-generator/issues/633)
- Can we exclude closed Requests [\#632](https://github.com/github-changelog-generator/github-changelog-generator/issues/632)
- Version in master branch hangs on MacOS [\#629](https://github.com/github-changelog-generator/github-changelog-generator/issues/629)
- Some PRs logged for the wrong releases [\#617](https://github.com/github-changelog-generator/github-changelog-generator/issues/617)
- since\_tag with unreleased tag unexpected behavior [\#604](https://github.com/github-changelog-generator/github-changelog-generator/issues/604)
- Generator doesn't work when I run the command presented in the docs [\#599](https://github.com/github-changelog-generator/github-changelog-generator/issues/599)
- Move repo to organisation [\#595](https://github.com/github-changelog-generator/github-changelog-generator/issues/595)
- Docker image does not exist on docker hub [\#593](https://github.com/github-changelog-generator/github-changelog-generator/issues/593)
- Dockerfile and Docker automated builds [\#591](https://github.com/github-changelog-generator/github-changelog-generator/issues/591)
- bug: Output on aborting when unknown user and project only prints out banner, not why it aborted [\#577](https://github.com/github-changelog-generator/github-changelog-generator/issues/577)
- Issues with 2 labels appear twice in the changelog [\#388](https://github.com/github-changelog-generator/github-changelog-generator/issues/388)

**Merged pull requests:**

- HTTP to HTTPS link [\#723](https://github.com/github-changelog-generator/github-changelog-generator/pull/723) ([blrhc](https://github.com/blrhc))
- Fix broken output example link in README [\#721](https://github.com/github-changelog-generator/github-changelog-generator/pull/721) ([djpowers](https://github.com/djpowers))
- Use MRI 2.6.2 in development [\#711](https://github.com/github-changelog-generator/github-changelog-generator/pull/711) ([olleolleolle](https://github.com/olleolleolle))
- Drop coveralls gem and configuration [\#710](https://github.com/github-changelog-generator/github-changelog-generator/pull/710) ([olleolleolle](https://github.com/olleolleolle))
- End support for Ruby 2.2 [\#709](https://github.com/github-changelog-generator/github-changelog-generator/pull/709) ([olleolleolle](https://github.com/olleolleolle))
- Drop AppVeyor builds [\#708](https://github.com/github-changelog-generator/github-changelog-generator/pull/708) ([olleolleolle](https://github.com/olleolleolle))
- Ruby version file: use 2.6.1 [\#707](https://github.com/github-changelog-generator/github-changelog-generator/pull/707) ([olleolleolle](https://github.com/olleolleolle))
- Use a complete shebang line in git subcommand [\#706](https://github.com/github-changelog-generator/github-changelog-generator/pull/706) ([olleolleolle](https://github.com/olleolleolle))
- CI: Make RuboCop a required, initial Workflow Job [\#705](https://github.com/github-changelog-generator/github-changelog-generator/pull/705) ([olleolleolle](https://github.com/olleolleolle))
- CI: Remove unused TravisCI configuration file [\#704](https://github.com/github-changelog-generator/github-changelog-generator/pull/704) ([olleolleolle](https://github.com/olleolleolle))
- Rubocop maintenance for 0.64.0 [\#703](https://github.com/github-changelog-generator/github-changelog-generator/pull/703) ([olleolleolle](https://github.com/olleolleolle))
- Gemspec: drop old setting default\_executable [\#702](https://github.com/github-changelog-generator/github-changelog-generator/pull/702) ([olleolleolle](https://github.com/olleolleolle))
- Fix tests [\#700](https://github.com/github-changelog-generator/github-changelog-generator/pull/700) ([unicolet](https://github.com/unicolet))
- Replace all skywinder occurrences to github-changelog-generator [\#698](https://github.com/github-changelog-generator/github-changelog-generator/pull/698) ([bodazhao](https://github.com/bodazhao))
- Update license date [\#696](https://github.com/github-changelog-generator/github-changelog-generator/pull/696) ([blrhc](https://github.com/blrhc))
- README: Install wording, notes on Docker [\#689](https://github.com/github-changelog-generator/github-changelog-generator/pull/689) ([aredshaw](https://github.com/aredshaw))
- Linting updates, spec fixes [\#680](https://github.com/github-changelog-generator/github-changelog-generator/pull/680) ([mob-sakai](https://github.com/mob-sakai))
- README: Include Example of Release Summary [\#679](https://github.com/github-changelog-generator/github-changelog-generator/pull/679) ([olleolleolle](https://github.com/olleolleolle))
- Remove redundant dependency [\#677](https://github.com/github-changelog-generator/github-changelog-generator/pull/677) ([mob-sakai](https://github.com/mob-sakai))
- fix \#668; Hang on pretty print of options in 1.15.0-rc [\#676](https://github.com/github-changelog-generator/github-changelog-generator/pull/676) ([mob-sakai](https://github.com/mob-sakai))
- Update `credit_line` [\#666](https://github.com/github-changelog-generator/github-changelog-generator/pull/666) ([sugyan](https://github.com/sugyan))
- Update octo\_fetcher.rb [\#661](https://github.com/github-changelog-generator/github-changelog-generator/pull/661) ([Skeyelab](https://github.com/Skeyelab))
- Add release summary section [\#654](https://github.com/github-changelog-generator/github-changelog-generator/pull/654) ([mob-sakai](https://github.com/mob-sakai))
- Add 'Backwards incompatible' as a default breaking label [\#650](https://github.com/github-changelog-generator/github-changelog-generator/pull/650) ([ekohl](https://github.com/ekohl))
- Update the README to reflect the required Rake-task options [\#648](https://github.com/github-changelog-generator/github-changelog-generator/pull/648) ([chocolateboy](https://github.com/chocolateboy))
- Travis: use jruby-9.1.17.0 [\#646](https://github.com/github-changelog-generator/github-changelog-generator/pull/646) ([olleolleolle](https://github.com/olleolleolle))
- Sort issues by detected actual\_date instead of closed\_at [\#640](https://github.com/github-changelog-generator/github-changelog-generator/pull/640) ([hunner](https://github.com/hunner))
- update parser.rb and git-generate-changelog.md, run ronn [\#637](https://github.com/github-changelog-generator/github-changelog-generator/pull/637) ([jennyknuth](https://github.com/jennyknuth))
- Issue \#558 Keepachangelog labels [\#636](https://github.com/github-changelog-generator/github-changelog-generator/pull/636) ([jennyknuth](https://github.com/jennyknuth))
- \[CI\] Test against Ruby 2.5 [\#635](https://github.com/github-changelog-generator/github-changelog-generator/pull/635) ([nicolasleger](https://github.com/nicolasleger))
- Remove docker bits [\#634](https://github.com/github-changelog-generator/github-changelog-generator/pull/634) ([ferrarimarco](https://github.com/ferrarimarco))
- Linty McLintface [\#628](https://github.com/github-changelog-generator/github-changelog-generator/pull/628) ([hunner](https://github.com/hunner))
- \(maint\) Make yard warn on incorrect yard docs [\#623](https://github.com/github-changelog-generator/github-changelog-generator/pull/623) ([hunner](https://github.com/hunner))
- Regenerate man, html docs [\#622](https://github.com/github-changelog-generator/github-changelog-generator/pull/622) ([olleolleolle](https://github.com/olleolleolle))
- Raise error instead of unhelpful behavior for --since-tag or --due-tag [\#621](https://github.com/github-changelog-generator/github-changelog-generator/pull/621) ([hunner](https://github.com/hunner))
- Optionally Print Issue and Pull Requests Body [\#616](https://github.com/github-changelog-generator/github-changelog-generator/pull/616) ([ArtieReus](https://github.com/ArtieReus))
- Linting: formatting code to suit RuboCop [\#611](https://github.com/github-changelog-generator/github-changelog-generator/pull/611) ([olleolleolle](https://github.com/olleolleolle))
- Update license date [\#610](https://github.com/github-changelog-generator/github-changelog-generator/pull/610) ([blrhc](https://github.com/blrhc))
- Update git-generate-changelog.md [\#607](https://github.com/github-changelog-generator/github-changelog-generator/pull/607) ([blrhc](https://github.com/blrhc))
- Capitalization and full stops [\#605](https://github.com/github-changelog-generator/github-changelog-generator/pull/605) ([blrhc](https://github.com/blrhc))
- RuboCop 0.52.0 linting [\#603](https://github.com/github-changelog-generator/github-changelog-generator/pull/603) ([olleolleolle](https://github.com/olleolleolle))
- Add $ or \# to indicate whether a command needs to be run as root or n… [\#602](https://github.com/github-changelog-generator/github-changelog-generator/pull/602) ([mueller-ma](https://github.com/mueller-ma))
- Error message correction [\#601](https://github.com/github-changelog-generator/github-changelog-generator/pull/601) ([blrhc](https://github.com/blrhc))
- Minor change [\#597](https://github.com/github-changelog-generator/github-changelog-generator/pull/597) ([blrhc](https://github.com/blrhc))
- minor cosmetic change [\#596](https://github.com/github-changelog-generator/github-changelog-generator/pull/596) ([blrhc](https://github.com/blrhc))
- Add option --configure-sections, --add-sections, --include-merged [\#587](https://github.com/github-changelog-generator/github-changelog-generator/pull/587) ([eputnam](https://github.com/eputnam))

## [v1.15.0.pre.rc](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.15.0.pre.rc) (2017-10-29)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.15.0.pre.beta...v1.15.0.pre.rc)

**Implemented enhancements:**

- Add option --require to load custom Ruby code before starting [\#574](https://github.com/github-changelog-generator/github-changelog-generator/pull/574) ([olleolleolle](https://github.com/olleolleolle))

**Fixed bugs:**

- issue\_line\_labels and breaking\_labels fail as rake file config params [\#583](https://github.com/github-changelog-generator/github-changelog-generator/issues/583)

**Merged pull requests:**

- Add Rake options reported missing [\#584](https://github.com/github-changelog-generator/github-changelog-generator/pull/584) ([olleolleolle](https://github.com/olleolleolle))
- Aborting on missing --user and --project prints all of usage [\#578](https://github.com/github-changelog-generator/github-changelog-generator/pull/578) ([olleolleolle](https://github.com/olleolleolle))
- Options\#print\_options + API docs for Options, Parser [\#576](https://github.com/github-changelog-generator/github-changelog-generator/pull/576) ([olleolleolle](https://github.com/olleolleolle))
- \[docs\] Contributing file [\#575](https://github.com/github-changelog-generator/github-changelog-generator/pull/575) ([olleolleolle](https://github.com/olleolleolle))

## [v1.15.0.pre.beta](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.15.0.pre.beta) (2017-10-13)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.15.0.pre.alpha...v1.15.0.pre.beta)

**Implemented enhancements:**

- add breaking-changes section to changelog [\#530](https://github.com/github-changelog-generator/github-changelog-generator/pull/530) ([bastelfreak](https://github.com/bastelfreak))
- Drop Project-and-Username-finding code [\#451](https://github.com/github-changelog-generator/github-changelog-generator/pull/451) ([olleolleolle](https://github.com/olleolleolle))

**Fixed bugs:**

- since\_tag doesn't work when tag specified is the latest tag [\#555](https://github.com/github-changelog-generator/github-changelog-generator/issues/555)
- since\_tag seems to not be working [\#304](https://github.com/github-changelog-generator/github-changelog-generator/issues/304)
- filter tags correctly when `since_tag` is set to most recent tag [\#566](https://github.com/github-changelog-generator/github-changelog-generator/pull/566) ([Crunch09](https://github.com/Crunch09))

**Closed issues:**

- SSL Cert issue on Windows [\#475](https://github.com/github-changelog-generator/github-changelog-generator/issues/475)

**Merged pull requests:**

- Fix regression w/ enhancements in issues\_to\_log [\#573](https://github.com/github-changelog-generator/github-changelog-generator/pull/573) ([ekohl](https://github.com/ekohl))
- OctoFetcher: Use defaults for request\_options [\#571](https://github.com/github-changelog-generator/github-changelog-generator/pull/571) ([olleolleolle](https://github.com/olleolleolle))
- OctoFetcher: extract methods [\#570](https://github.com/github-changelog-generator/github-changelog-generator/pull/570) ([olleolleolle](https://github.com/olleolleolle))
- OctoFetcher: extract method fail\_with\_message [\#569](https://github.com/github-changelog-generator/github-changelog-generator/pull/569) ([olleolleolle](https://github.com/olleolleolle))
- OctoFetcher: drop unused number\_of\_pages feature [\#568](https://github.com/github-changelog-generator/github-changelog-generator/pull/568) ([olleolleolle](https://github.com/olleolleolle))
- Travis: Do not test on jruby-head [\#567](https://github.com/github-changelog-generator/github-changelog-generator/pull/567) ([olleolleolle](https://github.com/olleolleolle))
- Drop unused Rake task [\#564](https://github.com/github-changelog-generator/github-changelog-generator/pull/564) ([olleolleolle](https://github.com/olleolleolle))
- Update license date [\#553](https://github.com/github-changelog-generator/github-changelog-generator/pull/553) ([blrhc](https://github.com/blrhc))

## [v1.15.0.pre.alpha](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.15.0.pre.alpha) (2017-10-01)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.14.3...v1.15.0.pre.alpha)

**Implemented enhancements:**

- Add newline after version name and Full Changelog link [\#548](https://github.com/github-changelog-generator/github-changelog-generator/pull/548) ([ianroberts131](https://github.com/ianroberts131))
- Update the token failure example to OctoKit 404 failure [\#525](https://github.com/github-changelog-generator/github-changelog-generator/pull/525) ([wompq](https://github.com/wompq))
- Rescue invalid commands and present the valid options list [\#498](https://github.com/github-changelog-generator/github-changelog-generator/pull/498) ([Lucashuang0802](https://github.com/Lucashuang0802))
- bundled cacert.pem with --ssl-ca-file PATH option [\#480](https://github.com/github-changelog-generator/github-changelog-generator/pull/480) ([olleolleolle](https://github.com/olleolleolle))
- Option parsing: Remove tag1, tag2 cruft [\#479](https://github.com/github-changelog-generator/github-changelog-generator/pull/479) ([olleolleolle](https://github.com/olleolleolle))

**Fixed bugs:**

- Credit line bug [\#541](https://github.com/github-changelog-generator/github-changelog-generator/issues/541)
- Bug: Credit line about this project added more than once [\#507](https://github.com/github-changelog-generator/github-changelog-generator/issues/507)
- v1.14.0 Fails with missing /tmp/ path on Windows [\#458](https://github.com/github-changelog-generator/github-changelog-generator/issues/458)
- failure when creating changelog from a repo in an orginazation: can't convert Github::ResponseWrapper to Array [\#253](https://github.com/github-changelog-generator/github-changelog-generator/issues/253)
- warn\_if\_nonmatching\_regex should display proper help message when used with exclude-tags-regex [\#551](https://github.com/github-changelog-generator/github-changelog-generator/pull/551) ([lacostej](https://github.com/lacostej))
- Bugfix: require ActiveSupport core\_ext/blank [\#520](https://github.com/github-changelog-generator/github-changelog-generator/pull/520) ([olleolleolle](https://github.com/olleolleolle))
- Create temporary cache files in Dir.tmpdir [\#459](https://github.com/github-changelog-generator/github-changelog-generator/pull/459) ([olleolleolle](https://github.com/olleolleolle))

**Closed issues:**

- error \(Windows: Command exited with code 1\) [\#536](https://github.com/github-changelog-generator/github-changelog-generator/issues/536)
- Error in generating changelog on Windows [\#521](https://github.com/github-changelog-generator/github-changelog-generator/issues/521)
- Crash on start [\#512](https://github.com/github-changelog-generator/github-changelog-generator/issues/512)
- Error On Running Generation Command [\#511](https://github.com/github-changelog-generator/github-changelog-generator/issues/511)
- Not working [\#510](https://github.com/github-changelog-generator/github-changelog-generator/issues/510)
- PR cited in the wrong TAG [\#503](https://github.com/github-changelog-generator/github-changelog-generator/issues/503)
- 404 Not Found Error [\#484](https://github.com/github-changelog-generator/github-changelog-generator/issues/484)

**Merged pull requests:**

- Travis: Configure cache: bundler: true [\#563](https://github.com/github-changelog-generator/github-changelog-generator/pull/563) ([olleolleolle](https://github.com/olleolleolle))
- Travis: use JRuby 9.1.13.0; don't redo rvm's job [\#562](https://github.com/github-changelog-generator/github-changelog-generator/pull/562) ([olleolleolle](https://github.com/olleolleolle))
- Travis: update CI matrix [\#561](https://github.com/github-changelog-generator/github-changelog-generator/pull/561) ([olleolleolle](https://github.com/olleolleolle))
- Fix section mapping, hiding untagged PRs, and hiding untagged issues [\#550](https://github.com/github-changelog-generator/github-changelog-generator/pull/550) ([hunner](https://github.com/hunner))
- Update generator\_generation.rb [\#542](https://github.com/github-changelog-generator/github-changelog-generator/pull/542) ([Lucashuang0802](https://github.com/Lucashuang0802))
- AppVeyor: drop init build hook, add .gitattributes instead [\#539](https://github.com/github-changelog-generator/github-changelog-generator/pull/539) ([olleolleolle](https://github.com/olleolleolle))
- AppVeyor: Windows configuration to pass RuboCop [\#538](https://github.com/github-changelog-generator/github-changelog-generator/pull/538) ([olleolleolle](https://github.com/olleolleolle))
- Fix the syntax ambiguity on credit-line-bug [\#537](https://github.com/github-changelog-generator/github-changelog-generator/pull/537) ([Lucashuang0802](https://github.com/Lucashuang0802))
- Credit line bug [\#535](https://github.com/github-changelog-generator/github-changelog-generator/pull/535) ([Lucashuang0802](https://github.com/Lucashuang0802))
- Update README.md [\#534](https://github.com/github-changelog-generator/github-changelog-generator/pull/534) ([Lucashuang0802](https://github.com/Lucashuang0802))
- Delete circle.yml [\#532](https://github.com/github-changelog-generator/github-changelog-generator/pull/532) ([Lucashuang0802](https://github.com/Lucashuang0802))
- Update README.md [\#531](https://github.com/github-changelog-generator/github-changelog-generator/pull/531) ([Lucashuang0802](https://github.com/Lucashuang0802))
- Remove all old credit lines in the output then add a new one [\#526](https://github.com/github-changelog-generator/github-changelog-generator/pull/526) ([stanislavkozlovski](https://github.com/stanislavkozlovski))
- Travis: jruby-9.1.10.0 [\#523](https://github.com/github-changelog-generator/github-changelog-generator/pull/523) ([olleolleolle](https://github.com/olleolleolle))
- Travis CI: Drop 2.1 [\#517](https://github.com/github-changelog-generator/github-changelog-generator/pull/517) ([olleolleolle](https://github.com/olleolleolle))
- Chore: Rubocop 0.49.0 [\#516](https://github.com/github-changelog-generator/github-changelog-generator/pull/516) ([olleolleolle](https://github.com/olleolleolle))
- Travis: use jruby-9.1.9.0 [\#506](https://github.com/github-changelog-generator/github-changelog-generator/pull/506) ([olleolleolle](https://github.com/olleolleolle))
- Use closed\_at and merged\_at when filtering issues/prs [\#504](https://github.com/github-changelog-generator/github-changelog-generator/pull/504) ([unicolet](https://github.com/unicolet))
- Remove --between-tags option [\#501](https://github.com/github-changelog-generator/github-changelog-generator/pull/501) ([Lucashuang0802](https://github.com/Lucashuang0802))
- Fixed headline in README.md [\#496](https://github.com/github-changelog-generator/github-changelog-generator/pull/496) ([Dreckiger-Dan](https://github.com/Dreckiger-Dan))
- Update README.md [\#490](https://github.com/github-changelog-generator/github-changelog-generator/pull/490) ([fatData](https://github.com/fatData))
- Travis: use latest rubies [\#488](https://github.com/github-changelog-generator/github-changelog-generator/pull/488) ([olleolleolle](https://github.com/olleolleolle))
- Use ruby-2.4.1 in CI [\#487](https://github.com/github-changelog-generator/github-changelog-generator/pull/487) ([olleolleolle](https://github.com/olleolleolle))
- Travis: jruby-9.1.8.0 [\#485](https://github.com/github-changelog-generator/github-changelog-generator/pull/485) ([olleolleolle](https://github.com/olleolleolle))
- Update to latest CodeClimate [\#478](https://github.com/github-changelog-generator/github-changelog-generator/pull/478) ([olleolleolle](https://github.com/olleolleolle))
- Gemspec: update retriable to 3.0 [\#477](https://github.com/github-changelog-generator/github-changelog-generator/pull/477) ([olleolleolle](https://github.com/olleolleolle))
- Travis: new JRuby, develop on 2.4.0 [\#476](https://github.com/github-changelog-generator/github-changelog-generator/pull/476) ([olleolleolle](https://github.com/olleolleolle))
- Fix readme typos [\#467](https://github.com/github-changelog-generator/github-changelog-generator/pull/467) ([dguo](https://github.com/dguo))
- Gemspec: demand rainbow 2.2.1+ [\#466](https://github.com/github-changelog-generator/github-changelog-generator/pull/466) ([olleolleolle](https://github.com/olleolleolle))

## [v1.14.3](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.14.3) (2016-12-31)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.14.2...v1.14.3)

**Fixed bugs:**

- Use Octokit::Client for both .com and Enterprise [\#455](https://github.com/github-changelog-generator/github-changelog-generator/pull/455) ([eliperkins](https://github.com/eliperkins))

**Closed issues:**

- Last tag contains too many PRs [\#291](https://github.com/github-changelog-generator/github-changelog-generator/issues/291)

**Merged pull requests:**

- CodeClimate configuration file [\#465](https://github.com/github-changelog-generator/github-changelog-generator/pull/465) ([olleolleolle](https://github.com/olleolleolle))
- Travis: Build against 2.4.0 [\#464](https://github.com/github-changelog-generator/github-changelog-generator/pull/464) ([olleolleolle](https://github.com/olleolleolle))
- Travis: add jruby-head, 2.4.0-rc1 [\#463](https://github.com/github-changelog-generator/github-changelog-generator/pull/463) ([olleolleolle](https://github.com/olleolleolle))
- Gemfiles for building versions separately dropped [\#461](https://github.com/github-changelog-generator/github-changelog-generator/pull/461) ([olleolleolle](https://github.com/olleolleolle))
- Order Gemfile gems A-Z; add ruby version marker [\#460](https://github.com/github-changelog-generator/github-changelog-generator/pull/460) ([olleolleolle](https://github.com/olleolleolle))
- README: Documentation update about RakeTask params and how to translate labels [\#454](https://github.com/github-changelog-generator/github-changelog-generator/pull/454) ([edusantana](https://github.com/edusantana))
- Travis: Use ruby 2.3.3 and 2.2.6 [\#452](https://github.com/github-changelog-generator/github-changelog-generator/pull/452) ([olleolleolle](https://github.com/olleolleolle))

## [v1.14.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.14.2) (2016-11-12)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.14.1...v1.14.2)

**Implemented enhancements:**

- OctoFetcher: Moved repositories fail explicitly [\#449](https://github.com/github-changelog-generator/github-changelog-generator/pull/449) ([olleolleolle](https://github.com/olleolleolle))

**Closed issues:**

- Error: can't convert Sawyer::Resource to Array when iterating over a 301 Moved Permanently [\#448](https://github.com/github-changelog-generator/github-changelog-generator/issues/448)

## [v1.14.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.14.1) (2016-11-06)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.14.0...v1.14.1)

**Closed issues:**

- multi\_json is required but is listed as a test dependency [\#444](https://github.com/github-changelog-generator/github-changelog-generator/issues/444)

**Merged pull requests:**

- Add multi\_json as a runtime dependency [\#445](https://github.com/github-changelog-generator/github-changelog-generator/pull/445) ([rnelson0](https://github.com/rnelson0))

## [v1.14.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.14.0) (2016-11-05)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.13.2...v1.14.0)

**Implemented enhancements:**

- On OctoKit::Forbidden error: retry with exponential backoff [\#434](https://github.com/github-changelog-generator/github-changelog-generator/pull/434) ([awaage](https://github.com/awaage))
- Use octokit, carrying awaage commits [\#422](https://github.com/github-changelog-generator/github-changelog-generator/pull/422) ([olleolleolle](https://github.com/olleolleolle))
- Add option to show selected labels in the issue line [\#418](https://github.com/github-changelog-generator/github-changelog-generator/pull/418) ([aih](https://github.com/aih))

**Fixed bugs:**

- unreleased and unreleased-label [\#374](https://github.com/github-changelog-generator/github-changelog-generator/issues/374)
- Problems installing 1.11.7 on Windows when git absent [\#349](https://github.com/github-changelog-generator/github-changelog-generator/issues/349)

**Closed issues:**

- broken issue-line-labels in log [\#442](https://github.com/github-changelog-generator/github-changelog-generator/issues/442)
- Broken multi hyphen options in param file [\#440](https://github.com/github-changelog-generator/github-changelog-generator/issues/440)
- Install error on Mac: "rack requires Ruby version \>= 2.2.2" [\#425](https://github.com/github-changelog-generator/github-changelog-generator/issues/425)
- Changelog includes issues going back months too far [\#394](https://github.com/github-changelog-generator/github-changelog-generator/issues/394)

**Merged pull requests:**

- Fixed issue \#442 - broken issue-line-labels in log. [\#443](https://github.com/github-changelog-generator/github-changelog-generator/pull/443) ([thorsteneckel](https://github.com/thorsteneckel))
- Fixed issue \#440 - broken multi hyphen options in param file. [\#441](https://github.com/github-changelog-generator/github-changelog-generator/pull/441) ([thorsteneckel](https://github.com/thorsteneckel))
- Option --unreleased-label explained [\#439](https://github.com/github-changelog-generator/github-changelog-generator/pull/439) ([olleolleolle](https://github.com/olleolleolle))
- Fixed issue \#304 - entries of previous tags are included. [\#438](https://github.com/github-changelog-generator/github-changelog-generator/pull/438) ([thorsteneckel](https://github.com/thorsteneckel))
- man page: Add undescribed options [\#437](https://github.com/github-changelog-generator/github-changelog-generator/pull/437) ([olleolleolle](https://github.com/olleolleolle))
- On GitHub MAX\_THREAD\_NUMBER is 25 [\#433](https://github.com/github-changelog-generator/github-changelog-generator/pull/433) ([olleolleolle](https://github.com/olleolleolle))
- OctoFetcher, Options: Refactoring [\#432](https://github.com/github-changelog-generator/github-changelog-generator/pull/432) ([olleolleolle](https://github.com/olleolleolle))
- Fix typo in Readme [\#431](https://github.com/github-changelog-generator/github-changelog-generator/pull/431) ([rmtheis](https://github.com/rmtheis))
- Fix: Turn Sawyer method into String-keyed hash access [\#429](https://github.com/github-changelog-generator/github-changelog-generator/pull/429) ([olleolleolle](https://github.com/olleolleolle))
- Spec: Test a url helper function [\#428](https://github.com/github-changelog-generator/github-changelog-generator/pull/428) ([olleolleolle](https://github.com/olleolleolle))
- Rubocop TODO file regenerated [\#427](https://github.com/github-changelog-generator/github-changelog-generator/pull/427) ([olleolleolle](https://github.com/olleolleolle))
- Drop a stray Markdown file [\#426](https://github.com/github-changelog-generator/github-changelog-generator/pull/426) ([olleolleolle](https://github.com/olleolleolle))
- Travis: Add JRuby 9.1.5.0 to matrix [\#424](https://github.com/github-changelog-generator/github-changelog-generator/pull/424) ([olleolleolle](https://github.com/olleolleolle))

## [1.13.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.13.2) (2016-09-29)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.13.2...1.13.2)

## [v1.13.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.13.2) (2016-09-29)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.13.1...v1.13.2)

**Implemented enhancements:**

- Replace GPL'd colorize gem with MIT-licensed rainbow [\#408](https://github.com/github-changelog-generator/github-changelog-generator/pull/408) ([jamesc](https://github.com/jamesc))
- Limit number of simultaneous requests to 25 [\#407](https://github.com/github-changelog-generator/github-changelog-generator/pull/407) ([jkeiser](https://github.com/jkeiser))
- Report actual github error when rate limit exceeded [\#405](https://github.com/github-changelog-generator/github-changelog-generator/pull/405) ([jkeiser](https://github.com/jkeiser))
- Make error messages print on error [\#404](https://github.com/github-changelog-generator/github-changelog-generator/pull/404) ([jkeiser](https://github.com/jkeiser))

**Fixed bugs:**

- Fetching events for issues and PRs triggers abuse rate limits [\#406](https://github.com/github-changelog-generator/github-changelog-generator/issues/406)

**Merged pull requests:**

- Add bump gem to development deps [\#423](https://github.com/github-changelog-generator/github-changelog-generator/pull/423) ([olleolleolle](https://github.com/olleolleolle))
- Skip logger helper in coverage [\#421](https://github.com/github-changelog-generator/github-changelog-generator/pull/421) ([olleolleolle](https://github.com/olleolleolle))
- Travis: Test on 2.4.0-preview2 [\#420](https://github.com/github-changelog-generator/github-changelog-generator/pull/420) ([olleolleolle](https://github.com/olleolleolle))
- Travis: Collecting the config, gemspec: extract development deps to Gemfile [\#417](https://github.com/github-changelog-generator/github-changelog-generator/pull/417) ([olleolleolle](https://github.com/olleolleolle))
- Update README.md [\#415](https://github.com/github-changelog-generator/github-changelog-generator/pull/415) ([dijonkitchen](https://github.com/dijonkitchen))
- README: Add Gitter badge [\#413](https://github.com/github-changelog-generator/github-changelog-generator/pull/413) ([olleolleolle](https://github.com/olleolleolle))
- CircleCI hook for Gitter notification [\#411](https://github.com/github-changelog-generator/github-changelog-generator/pull/411) ([olleolleolle](https://github.com/olleolleolle))
- Spec: avoid Ruby warning about already-defined constant [\#409](https://github.com/github-changelog-generator/github-changelog-generator/pull/409) ([olleolleolle](https://github.com/olleolleolle))

## [1.13.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.13.1) (2016-07-22)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.13.0...1.13.1)

**Implemented enhancements:**

- Don't constrain runtime deps. [\#400](https://github.com/github-changelog-generator/github-changelog-generator/pull/400) ([jkeiser](https://github.com/jkeiser))

**Fixed bugs:**

- `--user` flag should not be ignored [\#397](https://github.com/github-changelog-generator/github-changelog-generator/issues/397)
- GHE not working with --github-site set to an enterprise site [\#395](https://github.com/github-changelog-generator/github-changelog-generator/issues/395)

**Closed issues:**

- Contributors Section [\#398](https://github.com/github-changelog-generator/github-changelog-generator/issues/398)

**Merged pull requests:**

- Ability to implicity set user and project from command line [\#401](https://github.com/github-changelog-generator/github-changelog-generator/pull/401) ([skywinder](https://github.com/skywinder))
- Show how to use it with Rakefile [\#399](https://github.com/github-changelog-generator/github-changelog-generator/pull/399) ([edusantana](https://github.com/edusantana))
- Adds documentation on using a GHE endpoint [\#396](https://github.com/github-changelog-generator/github-changelog-generator/pull/396) ([cormacmccarthy](https://github.com/cormacmccarthy))
- Rake task usage: Added a missing option exclude\_tags\_regex [\#393](https://github.com/github-changelog-generator/github-changelog-generator/pull/393) ([perlun](https://github.com/perlun))
- Parser: YARD docstrings and a rename, and RegExp named capture groups [\#391](https://github.com/github-changelog-generator/github-changelog-generator/pull/391) ([olleolleolle](https://github.com/olleolleolle))

## [1.13.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.13.0) (2016-07-04)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.12.1...1.13.0)

**Merged pull requests:**

- Carry PR \#301: usernames\_as\_github\_logins [\#392](https://github.com/github-changelog-generator/github-changelog-generator/pull/392) ([olleolleolle](https://github.com/olleolleolle))

## [1.12.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.12.1) (2016-05-09)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.12.0...1.12.1)

**Fixed bugs:**

- NoMethodError on nil in detect\_since\_tag in github\_changelog\_generator/generator/generator\_tags.rb:61 [\#351](https://github.com/github-changelog-generator/github-changelog-generator/issues/351)

**Closed issues:**

- Add a LICENSE file [\#369](https://github.com/github-changelog-generator/github-changelog-generator/issues/369)
- Error installing on Ubuntu 14.04 [\#364](https://github.com/github-changelog-generator/github-changelog-generator/issues/364)

**Merged pull requests:**

- Move dev gems to add\_development\_dependency [\#373](https://github.com/github-changelog-generator/github-changelog-generator/pull/373) ([skywinder](https://github.com/skywinder))
- Add MIT LICENSE file [\#370](https://github.com/github-changelog-generator/github-changelog-generator/pull/370) ([olleolleolle](https://github.com/olleolleolle))
- Avoid nil bug in detect\_since\_tag [\#368](https://github.com/github-changelog-generator/github-changelog-generator/pull/368) ([olleolleolle](https://github.com/olleolleolle))

## [1.12.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.12.0) (2016-04-01)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.8...1.12.0)

**Closed issues:**

- .github\_changelog\_generator config file is not consistent with the internal options hash [\#312](https://github.com/github-changelog-generator/github-changelog-generator/issues/312)
- Feature request: YAML front matter [\#276](https://github.com/github-changelog-generator/github-changelog-generator/issues/276)

**Merged pull requests:**

- Added tag exclusion with a filter \(string or regex\) [\#320](https://github.com/github-changelog-generator/github-changelog-generator/pull/320) ([soundstep](https://github.com/soundstep))

## [1.11.8](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.8) (2016-03-22)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.7...1.11.8)

**Implemented enhancements:**

- ParserFile: Allow comments in settings file [\#358](https://github.com/github-changelog-generator/github-changelog-generator/pull/358) ([olleolleolle](https://github.com/olleolleolle))

**Fixed bugs:**

- Error when specifying exclude\_labels [\#327](https://github.com/github-changelog-generator/github-changelog-generator/issues/327)
- Parse options file options into arrays, integers, flags, and other [\#354](https://github.com/github-changelog-generator/github-changelog-generator/pull/354) ([olleolleolle](https://github.com/olleolleolle))

**Closed issues:**

- Installation fails on Ubuntu [\#352](https://github.com/github-changelog-generator/github-changelog-generator/issues/352)
- Test installing on Windows: use AppVeyor [\#348](https://github.com/github-changelog-generator/github-changelog-generator/issues/348)
- Can't run under RubyGems 2.5.1 and Ruby 2.3.0 [\#325](https://github.com/github-changelog-generator/github-changelog-generator/issues/325)
- Ruby 2.3.0 - Deprecation warning: Github::ResponseWrapper\#respond\_to?\(:to\_ary\) is old fashion which takes only one parameter [\#323](https://github.com/github-changelog-generator/github-changelog-generator/issues/323)
- between-tags and exclude-tags do not work in .github\_changelog\_generator [\#317](https://github.com/github-changelog-generator/github-changelog-generator/issues/317)
- Add a "documentation" label [\#284](https://github.com/github-changelog-generator/github-changelog-generator/issues/284)

**Merged pull requests:**

- Replace shelling-out-to-Git w/ Dir call [\#360](https://github.com/github-changelog-generator/github-changelog-generator/pull/360) ([olleolleolle](https://github.com/olleolleolle))
- ParserFile: fail parsing with config file line number; use a File instead of a filename [\#357](https://github.com/github-changelog-generator/github-changelog-generator/pull/357) ([olleolleolle](https://github.com/olleolleolle))
- On gem install, do not try to copy manpage files in the "extensions" step [\#356](https://github.com/github-changelog-generator/github-changelog-generator/pull/356) ([olleolleolle](https://github.com/olleolleolle))
- Refactor: call it option\_name, instead of key\_sym [\#355](https://github.com/github-changelog-generator/github-changelog-generator/pull/355) ([olleolleolle](https://github.com/olleolleolle))
- Add a `bundle install` test [\#353](https://github.com/github-changelog-generator/github-changelog-generator/pull/353) ([jkeiser](https://github.com/jkeiser))
- Add an AppVeyor config [\#350](https://github.com/github-changelog-generator/github-changelog-generator/pull/350) ([Arcanemagus](https://github.com/Arcanemagus))
- README: Document GitHub token URI scope [\#345](https://github.com/github-changelog-generator/github-changelog-generator/pull/345) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.7](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.7) (2016-03-04)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.6...1.11.7)

**Merged pull requests:**

- Add Olle Jonsson as co-author [\#347](https://github.com/github-changelog-generator/github-changelog-generator/pull/347) ([skywinder](https://github.com/skywinder))
- Gemspec, default date [\#346](https://github.com/github-changelog-generator/github-changelog-generator/pull/346) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.6](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.6) (2016-03-01)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.5...1.11.6)

**Fixed bugs:**

- Can't build on Windows [\#340](https://github.com/github-changelog-generator/github-changelog-generator/issues/340)

**Closed issues:**

- install error "Not a git repository" [\#339](https://github.com/github-changelog-generator/github-changelog-generator/issues/339)

**Merged pull requests:**

- Gemspec: Calculate date using Date stdlib [\#343](https://github.com/github-changelog-generator/github-changelog-generator/pull/343) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.5](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.5) (2016-03-01)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.4...1.11.5)

**Merged pull requests:**

- Test clean install in Travis [\#344](https://github.com/github-changelog-generator/github-changelog-generator/pull/344) ([jkeiser](https://github.com/jkeiser))
- Update Rakefile to avoid install-breaking bug [\#341](https://github.com/github-changelog-generator/github-changelog-generator/pull/341) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.4](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.4) (2016-02-26)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.3...1.11.4)

**Merged pull requests:**

- Man page copying: only copy .1 [\#338](https://github.com/github-changelog-generator/github-changelog-generator/pull/338) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.3](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.3) (2016-02-25)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.2...1.11.3)

**Closed issues:**

- Cannot install gem [\#335](https://github.com/github-changelog-generator/github-changelog-generator/issues/335)

## [1.11.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.2) (2016-02-25)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.1...1.11.2)

**Fixed bugs:**

- Getting an error on install [\#329](https://github.com/github-changelog-generator/github-changelog-generator/issues/329)

**Merged pull requests:**

- Fix installation by not running the specs - which have dependencies [\#337](https://github.com/github-changelog-generator/github-changelog-generator/pull/337) ([skywinder](https://github.com/skywinder))

## [1.11.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.1) (2016-02-25)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.11.0...1.11.1)

**Merged pull requests:**

- Add rubocop and rspec as runtime dependencies [\#336](https://github.com/github-changelog-generator/github-changelog-generator/pull/336) ([jkeiser](https://github.com/jkeiser))
- \[Refactor\] ParserFile class use Pathname [\#334](https://github.com/github-changelog-generator/github-changelog-generator/pull/334) ([olleolleolle](https://github.com/olleolleolle))
- \[Refactor\] Generator\#exclude\_issues\_by\_labels simpler, tested [\#332](https://github.com/github-changelog-generator/github-changelog-generator/pull/332) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.11.0) (2016-02-24)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.10.5...1.11.0)

## [1.10.5](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.10.5) (2016-02-24)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.10.4...1.10.5)

## [1.10.4](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.10.4) (2016-02-24)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.10.3...1.10.4)

**Fixed bugs:**

- Rake and Bundler as runtime deps [\#333](https://github.com/github-changelog-generator/github-changelog-generator/pull/333) ([olleolleolle](https://github.com/olleolleolle))

**Merged pull requests:**

- Test case for \#327 [\#331](https://github.com/github-changelog-generator/github-changelog-generator/pull/331) ([olleolleolle](https://github.com/olleolleolle))
- Fix crash installing on systems without overcommit [\#330](https://github.com/github-changelog-generator/github-changelog-generator/pull/330) ([jkeiser](https://github.com/jkeiser))

## [1.10.3](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.10.3) (2016-02-23)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.10.2...1.10.3)

## [1.10.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.10.2) (2016-02-23)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/v1.11.0...1.10.2)

## [v1.11.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/v1.11.0) (2016-02-23)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.10.1...v1.11.0)

**Implemented enhancements:**

- Cache API responses [\#361](https://github.com/github-changelog-generator/github-changelog-generator/issues/361)
- We should add a git-generate-changelog command. [\#255](https://github.com/github-changelog-generator/github-changelog-generator/issues/255)
- YAML front matter [\#322](https://github.com/github-changelog-generator/github-changelog-generator/pull/322) ([retorquere](https://github.com/retorquere))
- Git Subcommand [\#288](https://github.com/github-changelog-generator/github-changelog-generator/pull/288) ([dlanileonardo](https://github.com/dlanileonardo))

**Fixed bugs:**

- detect\_since\_tag undefined [\#328](https://github.com/github-changelog-generator/github-changelog-generator/issues/328)

**Merged pull requests:**

- Update README.md [\#324](https://github.com/github-changelog-generator/github-changelog-generator/pull/324) ([Zearin](https://github.com/Zearin))

## [1.10.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.10.1) (2016-01-06)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.10.0...1.10.1)

**Fixed bugs:**

- Parser: avoid Ruby exit, to make Rake tasks work [\#315](https://github.com/github-changelog-generator/github-changelog-generator/pull/315) ([olleolleolle](https://github.com/olleolleolle))

## [1.10.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.10.0) (2016-01-05)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.9.0...1.10.0)

**Implemented enhancements:**

- Rubocop: less complex methods in parser.rb [\#297](https://github.com/github-changelog-generator/github-changelog-generator/pull/297) ([olleolleolle](https://github.com/olleolleolle))
- Introduce ParserError exception class [\#296](https://github.com/github-changelog-generator/github-changelog-generator/pull/296) ([olleolleolle](https://github.com/olleolleolle))
- ParserFile: support values with equals signs [\#285](https://github.com/github-changelog-generator/github-changelog-generator/pull/285) ([olleolleolle](https://github.com/olleolleolle))

**Closed issues:**

- PRs not closed on master branch show up in changelog [\#280](https://github.com/github-changelog-generator/github-changelog-generator/issues/280)

**Merged pull requests:**

- Update bundler [\#306](https://github.com/github-changelog-generator/github-changelog-generator/pull/306) ([SteveGilvarry](https://github.com/SteveGilvarry))
- Fixes \#280 Add release-branch option to filter the Pull Requests [\#305](https://github.com/github-changelog-generator/github-changelog-generator/pull/305) ([SteveGilvarry](https://github.com/SteveGilvarry))
- Add options to def self.user\_and\_project\_from\_git to fix parser.rb:19… [\#303](https://github.com/github-changelog-generator/github-changelog-generator/pull/303) ([SteveGilvarry](https://github.com/SteveGilvarry))
- Git ignore coverage/ [\#300](https://github.com/github-changelog-generator/github-changelog-generator/pull/300) ([olleolleolle](https://github.com/olleolleolle))
- \[refactor\] Fix docblock datatype, use \#map [\#299](https://github.com/github-changelog-generator/github-changelog-generator/pull/299) ([olleolleolle](https://github.com/olleolleolle))
- \[refactor\] Reader: positive Boolean; unused \#map [\#298](https://github.com/github-changelog-generator/github-changelog-generator/pull/298) ([olleolleolle](https://github.com/olleolleolle))
- Add base option to RakeTask [\#287](https://github.com/github-changelog-generator/github-changelog-generator/pull/287) ([jkeiser](https://github.com/jkeiser))

## [1.9.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.9.0) (2015-09-17)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.8.5...1.9.0)

**Implemented enhancements:**

- Feature: exclude\_tags using regular expression [\#281](https://github.com/github-changelog-generator/github-changelog-generator/pull/281) ([olleolleolle](https://github.com/olleolleolle))
- Auto parse options from file .github\_changelog\_generator [\#278](https://github.com/github-changelog-generator/github-changelog-generator/pull/278) ([dlanileonardo](https://github.com/dlanileonardo))

## [1.8.5](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.8.5) (2015-09-15)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.8.4...1.8.5)

**Merged pull requests:**

- Rake task: Be able to set false value in config [\#279](https://github.com/github-changelog-generator/github-changelog-generator/pull/279) ([olleolleolle](https://github.com/olleolleolle))

## [1.8.4](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.8.4) (2015-09-01)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.8.3...1.8.4)

**Fixed bugs:**

- Sending OATH through -t fails [\#274](https://github.com/github-changelog-generator/github-changelog-generator/issues/274)

## [1.8.3](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.8.3) (2015-08-31)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.8.2...1.8.3)

**Merged pull requests:**

- Do not alter pull\_requests while iterating on it [\#271](https://github.com/github-changelog-generator/github-changelog-generator/pull/271) ([raphink](https://github.com/raphink))

## [1.8.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.8.2) (2015-08-26)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.8.1...1.8.2)

**Closed issues:**

- Output should not include security information [\#270](https://github.com/github-changelog-generator/github-changelog-generator/issues/270)

**Merged pull requests:**

- This PRi will fix \#274. [\#275](https://github.com/github-changelog-generator/github-changelog-generator/pull/275) ([skywinder](https://github.com/skywinder))

## [1.8.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.8.1) (2015-08-25)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.8.0...1.8.1)

**Implemented enhancements:**

- Honor labels for Pull Requests [\#266](https://github.com/github-changelog-generator/github-changelog-generator/pull/266) ([raphink](https://github.com/raphink))

**Merged pull requests:**

- Fix issue with missing events \(in case of events for issue \>30\) [\#268](https://github.com/github-changelog-generator/github-changelog-generator/pull/268) ([skywinder](https://github.com/skywinder))
- Use since\_tag as default for older\_tag [\#267](https://github.com/github-changelog-generator/github-changelog-generator/pull/267) ([raphink](https://github.com/raphink))

## [1.8.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.8.0) (2015-08-24)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.7.0...1.8.0)

**Implemented enhancements:**

- Generate change log since/due specific tag [\#254](https://github.com/github-changelog-generator/github-changelog-generator/issues/254)
- Add --base option [\#258](https://github.com/github-changelog-generator/github-changelog-generator/pull/258) ([raphink](https://github.com/raphink))

**Merged pull requests:**

- Add `--due-tag` option [\#265](https://github.com/github-changelog-generator/github-changelog-generator/pull/265) ([skywinder](https://github.com/skywinder))
- Add release\_url to rake task options [\#264](https://github.com/github-changelog-generator/github-changelog-generator/pull/264) ([raphink](https://github.com/raphink))
- Add a rake task [\#260](https://github.com/github-changelog-generator/github-changelog-generator/pull/260) ([raphink](https://github.com/raphink))
- Add release\_url option [\#259](https://github.com/github-changelog-generator/github-changelog-generator/pull/259) ([raphink](https://github.com/raphink))
- Add --since-tag [\#257](https://github.com/github-changelog-generator/github-changelog-generator/pull/257) ([raphink](https://github.com/raphink))

## [1.7.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.7.0) (2015-07-16)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.6.2...1.7.0)

**Implemented enhancements:**

- Custom header [\#251](https://github.com/github-changelog-generator/github-changelog-generator/issues/251)
- Arbitrary templates [\#242](https://github.com/github-changelog-generator/github-changelog-generator/issues/242)

## [1.6.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.6.2) (2015-07-16)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.6.1...1.6.2)

**Fixed bugs:**

- --unreleased-only broken [\#250](https://github.com/github-changelog-generator/github-changelog-generator/issues/250)

## [1.6.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.6.1) (2015-06-12)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.6.0...1.6.1)

**Implemented enhancements:**

- Ability to specify custom section header [\#241](https://github.com/github-changelog-generator/github-changelog-generator/issues/241)

**Fixed bugs:**

- not encapsulated character `<` [\#249](https://github.com/github-changelog-generator/github-changelog-generator/issues/249)

## [1.6.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.6.0) (2015-06-11)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.5.0...1.6.0)

**Implemented enhancements:**

- Issues with any label  except "bug", "enhancement" should not be excluded by default. [\#240](https://github.com/github-changelog-generator/github-changelog-generator/issues/240)
- Add ability to specify custom labels for enhancements & bugfixes [\#54](https://github.com/github-changelog-generator/github-changelog-generator/issues/54)

**Fixed bugs:**

- --user and --project options are broken [\#246](https://github.com/github-changelog-generator/github-changelog-generator/issues/246)
- Exclude and Include tags is broken [\#245](https://github.com/github-changelog-generator/github-changelog-generator/issues/245)

## [1.5.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.5.0) (2015-05-26)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.4.1...1.5.0)

**Implemented enhancements:**

- Show `Unreleased` section even when there is no tags in repo. [\#228](https://github.com/github-changelog-generator/github-changelog-generator/issues/228)
- Add option `--exclude-tags x,y,z` [\#214](https://github.com/github-changelog-generator/github-changelog-generator/issues/214)
- Generate change log between 2 specific tags [\#172](https://github.com/github-changelog-generator/github-changelog-generator/issues/172)
- Yanked releases support [\#53](https://github.com/github-changelog-generator/github-changelog-generator/issues/53)

**Merged pull requests:**

- Big refactoring [\#243](https://github.com/github-changelog-generator/github-changelog-generator/pull/243) ([skywinder](https://github.com/skywinder))

## [1.4.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.4.1) (2015-05-19)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.4.0...1.4.1)

**Implemented enhancements:**

- Trees/Archives with missing change log notes for the current tag. [\#230](https://github.com/github-changelog-generator/github-changelog-generator/issues/230)

**Fixed bugs:**

- github\_changelog\_generator.rb:220:in ``': No such file or directory - pwd \(Errno::ENOENT\) [\#237](https://github.com/github-changelog-generator/github-changelog-generator/issues/237)
- Doesnot generator changelog [\#235](https://github.com/github-changelog-generator/github-changelog-generator/issues/235)
- Exclude closed \(not merged\) PR's from changelog. [\#69](https://github.com/github-changelog-generator/github-changelog-generator/issues/69)

**Merged pull requests:**

- Wrap GitHub requests in function check\_github\_response [\#238](https://github.com/github-changelog-generator/github-changelog-generator/pull/238) ([skywinder](https://github.com/skywinder))
- Add fetch token tests [\#236](https://github.com/github-changelog-generator/github-changelog-generator/pull/236) ([skywinder](https://github.com/skywinder))
- Add future release option [\#231](https://github.com/github-changelog-generator/github-changelog-generator/pull/231) ([sildur](https://github.com/sildur))

## [1.4.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.4.0) (2015-05-07)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.11...1.4.0)

**Implemented enhancements:**

- Parsing of existing Change Log file [\#212](https://github.com/github-changelog-generator/github-changelog-generator/issues/212)
- Warn users about 0 tags in repo. [\#208](https://github.com/github-changelog-generator/github-changelog-generator/issues/208)
- Cleanup [\#220](https://github.com/github-changelog-generator/github-changelog-generator/pull/220) ([tuexss](https://github.com/tuexss))

**Closed issues:**

- Add CodeClimate and Inch CI [\#219](https://github.com/github-changelog-generator/github-changelog-generator/issues/219)

**Merged pull requests:**

- Implement fetcher class [\#227](https://github.com/github-changelog-generator/github-changelog-generator/pull/227) ([skywinder](https://github.com/skywinder))
- Add coveralls integration [\#223](https://github.com/github-changelog-generator/github-changelog-generator/pull/223) ([skywinder](https://github.com/skywinder))
- Rspec & rubocop integration [\#217](https://github.com/github-changelog-generator/github-changelog-generator/pull/217) ([skywinder](https://github.com/skywinder))
- Implement Reader class to parse ChangeLog.md [\#216](https://github.com/github-changelog-generator/github-changelog-generator/pull/216) ([estahn](https://github.com/estahn))
- Relatively require github\_changelog\_generator library [\#207](https://github.com/github-changelog-generator/github-changelog-generator/pull/207) ([sneal](https://github.com/sneal))
- Add --max-issues argument to limit requests [\#76](https://github.com/github-changelog-generator/github-changelog-generator/pull/76) ([sneal](https://github.com/sneal))

## [1.3.11](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.11) (2015-03-21)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.10...1.3.11)

**Merged pull requests:**

- Add  fallback with warning message to prevent crash in case of exceed API Rate Limit \(temporary workaround for \#71\) [\#75](https://github.com/github-changelog-generator/github-changelog-generator/pull/75) ([skywinder](https://github.com/skywinder))

## [1.3.10](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.10) (2015-03-18)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.9...1.3.10)

**Fixed bugs:**

- Fix termination in case of empty unreleased section with `--unreleased-only` option. [\#70](https://github.com/github-changelog-generator/github-changelog-generator/pull/70) ([skywinder](https://github.com/skywinder))

## [1.3.9](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.9) (2015-03-06)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.8...1.3.9)

**Implemented enhancements:**

- Improve method of detecting owner and repository [\#63](https://github.com/github-changelog-generator/github-changelog-generator/issues/63)

**Fixed bugs:**

- Resolved concurrency problem in case of issues \> 2048 [\#65](https://github.com/github-changelog-generator/github-changelog-generator/pull/65) ([skywinder](https://github.com/skywinder))

## [1.3.8](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.8) (2015-03-05)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.6...1.3.8)

## [1.3.6](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.6) (2015-03-05)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.5...1.3.6)

## [1.3.5](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.5) (2015-03-04)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.4...1.3.5)

**Fixed bugs:**

- Pull Requests in Wrong Tag [\#60](https://github.com/github-changelog-generator/github-changelog-generator/issues/60)

## [1.3.4](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.4) (2015-03-03)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.3...1.3.4)

**Fixed bugs:**

- --no-issues appears to break PRs [\#59](https://github.com/github-changelog-generator/github-changelog-generator/issues/59)

## [1.3.3](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.3) (2015-03-03)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.2...1.3.3)

**Closed issues:**

- Add \# character to encapsulate list. [\#58](https://github.com/github-changelog-generator/github-changelog-generator/issues/58)

## [1.3.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.2) (2015-03-03)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.1...1.3.2)

**Fixed bugs:**

- generation failed if github commit api return `404 Not Found` [\#57](https://github.com/github-changelog-generator/github-changelog-generator/issues/57)

## [1.3.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.1) (2015-02-27)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.3.0...1.3.1)

## [1.3.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.3.0) (2015-02-26)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.8...1.3.0)

**Implemented enhancements:**

- Do not show `Unreleased` section, when it's empty. [\#55](https://github.com/github-changelog-generator/github-changelog-generator/issues/55)
- Separate list exclude and include labels [\#52](https://github.com/github-changelog-generator/github-changelog-generator/issues/52)
- Unreleased issues in separate section [\#47](https://github.com/github-changelog-generator/github-changelog-generator/issues/47)
- Separate by lists: Enhancements, Bugs, Pull requests. [\#31](https://github.com/github-changelog-generator/github-changelog-generator/issues/31)

**Fixed bugs:**

- Pull request with invalid label \(\#26\) in changelog appeared. [\#44](https://github.com/github-changelog-generator/github-changelog-generator/issues/44)

**Merged pull requests:**

- Implement filtering of Pull Requests by milestones [\#50](https://github.com/github-changelog-generator/github-changelog-generator/pull/50) ([skywinder](https://github.com/skywinder))

## [1.2.8](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.8) (2015-02-17)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.7...1.2.8)

**Closed issues:**

- Bugs, that closed simultaneously with push not appeared in correct version. [\#37](https://github.com/github-changelog-generator/github-changelog-generator/issues/37)

**Merged pull requests:**

- Feature/fix 37 [\#49](https://github.com/github-changelog-generator/github-changelog-generator/pull/49) ([skywinder](https://github.com/skywinder))
- Prettify output [\#48](https://github.com/github-changelog-generator/github-changelog-generator/pull/48) ([skywinder](https://github.com/skywinder))

## [1.2.7](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.7) (2015-01-26)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.6...1.2.7)

**Implemented enhancements:**

- Add compare link between older version and newer version [\#46](https://github.com/github-changelog-generator/github-changelog-generator/pull/46) ([sue445](https://github.com/sue445))

## [1.2.6](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.6) (2015-01-21)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.5...1.2.6)

**Merged pull requests:**

- fix link tag format [\#45](https://github.com/github-changelog-generator/github-changelog-generator/pull/45) ([sugamasao](https://github.com/sugamasao))

## [1.2.5](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.5) (2015-01-15)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.4...1.2.5)

**Implemented enhancements:**

- Use milestone to specify in which version bug was fixed [\#22](https://github.com/github-changelog-generator/github-changelog-generator/issues/22)
- support enterprise github via command line options [\#42](https://github.com/github-changelog-generator/github-changelog-generator/pull/42) ([glenlovett](https://github.com/glenlovett))

**Fixed bugs:**

- Error when trying to generate log for repo without tags [\#32](https://github.com/github-changelog-generator/github-changelog-generator/issues/32)
- PrettyPrint class is included using lowercase 'pp' [\#43](https://github.com/github-changelog-generator/github-changelog-generator/pull/43) ([schwing](https://github.com/schwing))

## [1.2.4](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.4) (2014-12-16)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.3...1.2.4)

**Fixed bugs:**

- Sometimes user is NULL during merges [\#41](https://github.com/github-changelog-generator/github-changelog-generator/issues/41)
- Crash when try generate log for rails [\#35](https://github.com/github-changelog-generator/github-changelog-generator/issues/35)

## [1.2.3](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.3) (2014-12-16)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.2...1.2.3)

**Implemented enhancements:**

- Add ability to run with one parameter instead -u -p [\#38](https://github.com/github-changelog-generator/github-changelog-generator/issues/38)
- Detailed output [\#33](https://github.com/github-changelog-generator/github-changelog-generator/issues/33)

**Fixed bugs:**

- Docs lacking or basic behavior not as advertised [\#30](https://github.com/github-changelog-generator/github-changelog-generator/issues/30)

**Merged pull requests:**

- Implement async fetching [\#39](https://github.com/github-changelog-generator/github-changelog-generator/pull/39) ([skywinder](https://github.com/skywinder))
- Fix crash when user is NULL [\#40](https://github.com/github-changelog-generator/github-changelog-generator/pull/40) ([skywinder](https://github.com/skywinder))

## [1.2.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.2) (2014-12-10)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.1...1.2.2)

**Fixed bugs:**

- Encapsulate \[ \> \* \_ \ \] signs in issues names [\#34](https://github.com/github-changelog-generator/github-changelog-generator/issues/34)

## [1.2.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.1) (2014-11-22)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.2.0...1.2.1)

**Fixed bugs:**

- Script fills changelog only for first 30 tags. [\#20](https://github.com/github-changelog-generator/github-changelog-generator/issues/20)

**Merged pull requests:**

- Issues for last tag not in list [\#29](https://github.com/github-changelog-generator/github-changelog-generator/pull/29) ([skywinder](https://github.com/skywinder))
- Disable default --filter-pull-requests option. [\#28](https://github.com/github-changelog-generator/github-changelog-generator/pull/28) ([skywinder](https://github.com/skywinder))

## [1.2.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.2.0) (2014-11-19)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.1.4...1.2.0)

**Merged pull requests:**

- Add filter for pull-requests labels. \(option --filter-pull-requests\) [\#27](https://github.com/github-changelog-generator/github-changelog-generator/pull/27) ([skywinder](https://github.com/skywinder))
- Add ability to insert authors of pull-requests \(--\[no-\]author option\) [\#25](https://github.com/github-changelog-generator/github-changelog-generator/pull/25) ([skywinder](https://github.com/skywinder))
- Don't receive issues in case of --no-isses flag specied [\#24](https://github.com/github-changelog-generator/github-changelog-generator/pull/24) ([skywinder](https://github.com/skywinder))

## [1.1.4](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.1.4) (2014-11-18)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.1.2...1.1.4)

**Implemented enhancements:**

- Implement ability to retrieve GitHub token from ENV variable \(to not put it to script directly\) [\#19](https://github.com/github-changelog-generator/github-changelog-generator/issues/19)

**Merged pull requests:**

- Sort tags by date [\#23](https://github.com/github-changelog-generator/github-changelog-generator/pull/23) ([skywinder](https://github.com/skywinder))

## [1.1.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.1.2) (2014-11-12)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.1.1...1.1.2)

**Merged pull requests:**

- Fix bug with dot signs in project name [\#18](https://github.com/github-changelog-generator/github-changelog-generator/pull/18) ([skywinder](https://github.com/skywinder))
- Fix bug with dot signs in user name [\#17](https://github.com/github-changelog-generator/github-changelog-generator/pull/17) ([skywinder](https://github.com/skywinder))

## [1.1.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.1.1) (2014-11-10)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.1.0...1.1.1)

**Merged pull requests:**

- Remove duplicates of issues and pull-requests with same number [\#15](https://github.com/github-changelog-generator/github-changelog-generator/pull/15) ([skywinder](https://github.com/skywinder))
- Sort issues by tags [\#14](https://github.com/github-changelog-generator/github-changelog-generator/pull/14) ([skywinder](https://github.com/skywinder))
- Add ability to add or exclude issues without any labels [\#13](https://github.com/github-changelog-generator/github-changelog-generator/pull/13) ([skywinder](https://github.com/skywinder))

## [1.1.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.1.0) (2014-11-10)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.0.1...1.1.0)

**Implemented enhancements:**

- Detect username and project form origin [\#11](https://github.com/github-changelog-generator/github-changelog-generator/issues/11)

**Fixed bugs:**

- Bug with wrong credentials in 1.0.1 [\#12](https://github.com/github-changelog-generator/github-changelog-generator/issues/12)
- Markdown formating in the last line wrong [\#9](https://github.com/github-changelog-generator/github-changelog-generator/issues/9)

## [1.0.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.0.1) (2014-11-10)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/1.0.0) (2014-11-07)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/0.1.0...1.0.0)

**Implemented enhancements:**

- Add support for fixed issues and implemented enchanments. [\#6](https://github.com/github-changelog-generator/github-changelog-generator/issues/6)
- Implement option to specify output filename [\#4](https://github.com/github-changelog-generator/github-changelog-generator/issues/4)
- Implement support of different tags. [\#8](https://github.com/github-changelog-generator/github-changelog-generator/pull/8) ([skywinder](https://github.com/skywinder))

**Fixed bugs:**

- Last tag not appeared in changelog [\#5](https://github.com/github-changelog-generator/github-changelog-generator/issues/5)

**Merged pull requests:**

- Add support for issues in CHANGELOG [\#7](https://github.com/github-changelog-generator/github-changelog-generator/pull/7) ([skywinder](https://github.com/skywinder))

## [0.1.0](https://github.com/github-changelog-generator/github-changelog-generator/tree/0.1.0) (2014-11-07)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/0.0.2...0.1.0)

**Merged pull requests:**

- Fix parsing date of pull request [\#3](https://github.com/github-changelog-generator/github-changelog-generator/pull/3) ([skywinder](https://github.com/skywinder))
- Add changelog generation for last tag [\#2](https://github.com/github-changelog-generator/github-changelog-generator/pull/2) ([skywinder](https://github.com/skywinder))
- Add option \(-o --output\) to specify name of the output file. [\#1](https://github.com/github-changelog-generator/github-changelog-generator/pull/1) ([skywinder](https://github.com/skywinder))

## [0.0.2](https://github.com/github-changelog-generator/github-changelog-generator/tree/0.0.2) (2014-11-06)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/github-changelog-generator/github-changelog-generator/tree/0.0.1) (2014-11-06)

[Full Changelog](https://github.com/github-changelog-generator/github-changelog-generator/compare/2a5b354410a422e2046f8d95b019df5985b003e4...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
