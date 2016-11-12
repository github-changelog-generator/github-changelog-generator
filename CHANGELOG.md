# Change Log

## [v1.14.2](https://github.com/skywinder/github-changelog-generator/tree/v1.14.2) (2016-11-12)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/v1.14.1...v1.14.2)

**Implemented enhancements:**

- We should add a git-generate-changelog command. [\#255](https://github.com/skywinder/github-changelog-generator/issues/255)
- OctoFetcher: Moved repositories fail explicitly [\#449](https://github.com/skywinder/github-changelog-generator/pull/449) ([olleolleolle](https://github.com/olleolleolle))

**Closed issues:**

- Error: can't convert Sawyer::Resource to Array when iterating over a 301 Moved Permanently [\#448](https://github.com/skywinder/github-changelog-generator/issues/448)

## [v1.14.1](https://github.com/skywinder/github-changelog-generator/tree/v1.14.1) (2016-11-06)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/v1.14.0...v1.14.1)

**Closed issues:**

- multi\_json is required but is listed as a test dependency [\#444](https://github.com/skywinder/github-changelog-generator/issues/444)

**Merged pull requests:**

- Add multi\_json as a runtime dependency [\#445](https://github.com/skywinder/github-changelog-generator/pull/445) ([rnelson0](https://github.com/rnelson0))

## [v1.14.0](https://github.com/skywinder/github-changelog-generator/tree/v1.14.0) (2016-11-05)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/v1.13.2...v1.14.0)

**Implemented enhancements:**

- On OctoKit::Forbidden error: retry with exponential backoff [\#434](https://github.com/skywinder/github-changelog-generator/pull/434) ([awaage](https://github.com/awaage))
- Use octokit, carrying awaage commits [\#422](https://github.com/skywinder/github-changelog-generator/pull/422) ([olleolleolle](https://github.com/olleolleolle))
- Add option to show selected labels in the issue line [\#418](https://github.com/skywinder/github-changelog-generator/pull/418) ([aih](https://github.com/aih))

**Fixed bugs:**

- unreleased and unreleased-label [\#374](https://github.com/skywinder/github-changelog-generator/issues/374)
- Problems installing 1.11.7 on Windows when git absent [\#349](https://github.com/skywinder/github-changelog-generator/issues/349)

**Closed issues:**

- broken issue-line-labels in log [\#442](https://github.com/skywinder/github-changelog-generator/issues/442)
- Broken multi hyphen options in param file [\#440](https://github.com/skywinder/github-changelog-generator/issues/440)
- Install error on Mac: "rack requires Ruby version \>= 2.2.2" [\#425](https://github.com/skywinder/github-changelog-generator/issues/425)
- Changelog includes issues going back months too far [\#394](https://github.com/skywinder/github-changelog-generator/issues/394)

**Merged pull requests:**

- Fixed issue \#442 - broken issue-line-labels in log. [\#443](https://github.com/skywinder/github-changelog-generator/pull/443) ([thorsteneckel](https://github.com/thorsteneckel))
- Fixed issue \#440 - broken multi hyphen options in param file. [\#441](https://github.com/skywinder/github-changelog-generator/pull/441) ([thorsteneckel](https://github.com/thorsteneckel))
- Option --unreleased-label explained [\#439](https://github.com/skywinder/github-changelog-generator/pull/439) ([olleolleolle](https://github.com/olleolleolle))
- Fixed issue \#304 - entries of previous tags are included. [\#438](https://github.com/skywinder/github-changelog-generator/pull/438) ([thorsteneckel](https://github.com/thorsteneckel))
- man page: Add undescribed options [\#437](https://github.com/skywinder/github-changelog-generator/pull/437) ([olleolleolle](https://github.com/olleolleolle))
- On GitHub MAX\_THREAD\_NUMBER is 25 [\#433](https://github.com/skywinder/github-changelog-generator/pull/433) ([olleolleolle](https://github.com/olleolleolle))
- OctoFetcher, Options: Refactoring [\#432](https://github.com/skywinder/github-changelog-generator/pull/432) ([olleolleolle](https://github.com/olleolleolle))
- Fix typo in Readme [\#431](https://github.com/skywinder/github-changelog-generator/pull/431) ([rmtheis](https://github.com/rmtheis))
- Fix: Turn Sawyer method into String-keyed hash access [\#429](https://github.com/skywinder/github-changelog-generator/pull/429) ([olleolleolle](https://github.com/olleolleolle))
- Spec: Test a url helper function [\#428](https://github.com/skywinder/github-changelog-generator/pull/428) ([olleolleolle](https://github.com/olleolleolle))
- Rubocop TODO file regenerated [\#427](https://github.com/skywinder/github-changelog-generator/pull/427) ([olleolleolle](https://github.com/olleolleolle))
- Drop a stray Markdown file [\#426](https://github.com/skywinder/github-changelog-generator/pull/426) ([olleolleolle](https://github.com/olleolleolle))
- Travis: Add JRuby 9.1.5.0 to matrix [\#424](https://github.com/skywinder/github-changelog-generator/pull/424) ([olleolleolle](https://github.com/olleolleolle))

## [v1.13.2](https://github.com/skywinder/github-changelog-generator/tree/v1.13.2) (2016-09-29)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.13.2...v1.13.2)

## [1.13.2](https://github.com/skywinder/github-changelog-generator/tree/1.13.2) (2016-09-29)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.13.1...1.13.2)

**Implemented enhancements:**

- Replace GPL'd colorize gem with MIT-licensed rainbow [\#408](https://github.com/skywinder/github-changelog-generator/pull/408) ([jamesc](https://github.com/jamesc))
- Limit number of simultaneous requests to 25 [\#407](https://github.com/skywinder/github-changelog-generator/pull/407) ([jkeiser](https://github.com/jkeiser))
- Report actual github error when rate limit exceeded [\#405](https://github.com/skywinder/github-changelog-generator/pull/405) ([jkeiser](https://github.com/jkeiser))
- Make error messages print on error [\#404](https://github.com/skywinder/github-changelog-generator/pull/404) ([jkeiser](https://github.com/jkeiser))

**Fixed bugs:**

- Fetching events for issues and PRs triggers abuse rate limits [\#406](https://github.com/skywinder/github-changelog-generator/issues/406)

**Merged pull requests:**

- Add bump gem to development deps [\#423](https://github.com/skywinder/github-changelog-generator/pull/423) ([olleolleolle](https://github.com/olleolleolle))
- Skip logger helper in coverage [\#421](https://github.com/skywinder/github-changelog-generator/pull/421) ([olleolleolle](https://github.com/olleolleolle))
- Travis: Test on 2.4.0-preview2 [\#420](https://github.com/skywinder/github-changelog-generator/pull/420) ([olleolleolle](https://github.com/olleolleolle))
- Travis: Collecting the config, gemspec: extract development deps to Gemfile [\#417](https://github.com/skywinder/github-changelog-generator/pull/417) ([olleolleolle](https://github.com/olleolleolle))
- Update README.md [\#415](https://github.com/skywinder/github-changelog-generator/pull/415) ([dijonkitchen](https://github.com/dijonkitchen))
- README: Add Gitter badge [\#413](https://github.com/skywinder/github-changelog-generator/pull/413) ([olleolleolle](https://github.com/olleolleolle))
- CircleCI hook for Gitter notification [\#411](https://github.com/skywinder/github-changelog-generator/pull/411) ([olleolleolle](https://github.com/olleolleolle))
- Spec: avoid Ruby warning about already-defined constant [\#409](https://github.com/skywinder/github-changelog-generator/pull/409) ([olleolleolle](https://github.com/olleolleolle))

## [1.13.1](https://github.com/skywinder/github-changelog-generator/tree/1.13.1) (2016-07-22)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.13.0...1.13.1)

**Implemented enhancements:**

- Don't constrain runtime deps. [\#400](https://github.com/skywinder/github-changelog-generator/pull/400) ([jkeiser](https://github.com/jkeiser))

**Fixed bugs:**

- `--user` flag should not be ignored [\#397](https://github.com/skywinder/github-changelog-generator/issues/397)
- GHE not working with --github-site set to an enterprise site [\#395](https://github.com/skywinder/github-changelog-generator/issues/395)

**Closed issues:**

- Contributors Section [\#398](https://github.com/skywinder/github-changelog-generator/issues/398)

**Merged pull requests:**

- Ability to implicity set user and project from command line [\#401](https://github.com/skywinder/github-changelog-generator/pull/401) ([skywinder](https://github.com/skywinder))
- Show how to use it with Rakefile [\#399](https://github.com/skywinder/github-changelog-generator/pull/399) ([edusantana](https://github.com/edusantana))
- Adds documentation on using a GHE endpoint [\#396](https://github.com/skywinder/github-changelog-generator/pull/396) ([cormacmccarthy](https://github.com/cormacmccarthy))
- Rake task usage: Added a missing option exclude\_tags\_regex [\#393](https://github.com/skywinder/github-changelog-generator/pull/393) ([perlun](https://github.com/perlun))
- Parser: YARD docstrings and a rename, and RegExp named capture groups [\#391](https://github.com/skywinder/github-changelog-generator/pull/391) ([olleolleolle](https://github.com/olleolleolle))

## [1.13.0](https://github.com/skywinder/github-changelog-generator/tree/1.13.0) (2016-07-04)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.12.1...1.13.0)

**Merged pull requests:**

- Carry PR \#301: usernames\_as\_github\_logins [\#392](https://github.com/skywinder/github-changelog-generator/pull/392) ([olleolleolle](https://github.com/olleolleolle))

## [1.12.1](https://github.com/skywinder/github-changelog-generator/tree/1.12.1) (2016-05-09)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.12.0...1.12.1)

**Fixed bugs:**

- github\_changelog\_generator/generator/generator\_tags.rb:61:in `detect\_since\_tag': undefined method `\[\]' for nil:NilClass \(NoMethodError\) [\#351](https://github.com/skywinder/github-changelog-generator/issues/351)

**Closed issues:**

- Add a LICENSE file [\#369](https://github.com/skywinder/github-changelog-generator/issues/369)
- Error installing on Ubuntu 14.04 [\#364](https://github.com/skywinder/github-changelog-generator/issues/364)

**Merged pull requests:**

- Move dev gems to add\_development\_dependency [\#373](https://github.com/skywinder/github-changelog-generator/pull/373) ([skywinder](https://github.com/skywinder))
- Add MIT LICENSE file [\#370](https://github.com/skywinder/github-changelog-generator/pull/370) ([olleolleolle](https://github.com/olleolleolle))
- Avoid nil bug in detect\_since\_tag [\#368](https://github.com/skywinder/github-changelog-generator/pull/368) ([olleolleolle](https://github.com/olleolleolle))

## [1.12.0](https://github.com/skywinder/github-changelog-generator/tree/1.12.0) (2016-04-01)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.8...1.12.0)

**Closed issues:**

- .github\_changelog\_generator config file is not consistent with the internal options hash [\#312](https://github.com/skywinder/github-changelog-generator/issues/312)
- Feature request: YAML front matter [\#276](https://github.com/skywinder/github-changelog-generator/issues/276)

**Merged pull requests:**

- Added tag exclusion with a filter \(string or regex\) [\#320](https://github.com/skywinder/github-changelog-generator/pull/320) ([soundstep](https://github.com/soundstep))

## [1.11.8](https://github.com/skywinder/github-changelog-generator/tree/1.11.8) (2016-03-22)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.7...1.11.8)

**Implemented enhancements:**

- ParserFile: Allow comments in settings file [\#358](https://github.com/skywinder/github-changelog-generator/pull/358) ([olleolleolle](https://github.com/olleolleolle))

**Fixed bugs:**

- Error when specifying exclude\_labels [\#327](https://github.com/skywinder/github-changelog-generator/issues/327)
- Parse options file options into arrays, integers, flags, and other [\#354](https://github.com/skywinder/github-changelog-generator/pull/354) ([olleolleolle](https://github.com/olleolleolle))

**Closed issues:**

- Installation fails on Ubuntu [\#352](https://github.com/skywinder/github-changelog-generator/issues/352)
- Test installing on Windows: use AppVeyor [\#348](https://github.com/skywinder/github-changelog-generator/issues/348)
- Can't run under RubyGems 2.5.1 and Ruby 2.3.0 [\#325](https://github.com/skywinder/github-changelog-generator/issues/325)
- Ruby 2.3.0 - Deprecation warning: Github::ResponseWrapper\#respond\_to?\(:to\_ary\) is old fashion which takes only one parameter [\#323](https://github.com/skywinder/github-changelog-generator/issues/323)
- between-tags and exclude-tags do not work in .github\_changelog\_generator [\#317](https://github.com/skywinder/github-changelog-generator/issues/317)
- Add a "documentation" label [\#284](https://github.com/skywinder/github-changelog-generator/issues/284)

**Merged pull requests:**

- Replace shelling-out-to-Git w/ Dir call [\#360](https://github.com/skywinder/github-changelog-generator/pull/360) ([olleolleolle](https://github.com/olleolleolle))
- ParserFile: fail parsing with config file line number; use a File instead of a filename [\#357](https://github.com/skywinder/github-changelog-generator/pull/357) ([olleolleolle](https://github.com/olleolleolle))
- On gem install, do not try to copy manpage files in the "extensions" step [\#356](https://github.com/skywinder/github-changelog-generator/pull/356) ([olleolleolle](https://github.com/olleolleolle))
- Refactor: call it option\_name, instead of key\_sym [\#355](https://github.com/skywinder/github-changelog-generator/pull/355) ([olleolleolle](https://github.com/olleolleolle))
- Add a `bundle install` test [\#353](https://github.com/skywinder/github-changelog-generator/pull/353) ([jkeiser](https://github.com/jkeiser))
- Add an AppVeyor config [\#350](https://github.com/skywinder/github-changelog-generator/pull/350) ([Arcanemagus](https://github.com/Arcanemagus))
- README: Document GitHub token URI scope [\#345](https://github.com/skywinder/github-changelog-generator/pull/345) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.7](https://github.com/skywinder/github-changelog-generator/tree/1.11.7) (2016-03-04)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.6...1.11.7)

**Merged pull requests:**

- Add Olle Jonsson as co-author [\#347](https://github.com/skywinder/github-changelog-generator/pull/347) ([skywinder](https://github.com/skywinder))
- Gemspec, default date [\#346](https://github.com/skywinder/github-changelog-generator/pull/346) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.6](https://github.com/skywinder/github-changelog-generator/tree/1.11.6) (2016-03-01)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.5...1.11.6)

**Fixed bugs:**

- Can't build on Windows [\#340](https://github.com/skywinder/github-changelog-generator/issues/340)

**Closed issues:**

- install error "Not a git repository" [\#339](https://github.com/skywinder/github-changelog-generator/issues/339)

**Merged pull requests:**

- Gemspec: Calculate date using Date stdlib [\#343](https://github.com/skywinder/github-changelog-generator/pull/343) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.5](https://github.com/skywinder/github-changelog-generator/tree/1.11.5) (2016-03-01)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.4...1.11.5)

**Merged pull requests:**

- Test clean install in Travis [\#344](https://github.com/skywinder/github-changelog-generator/pull/344) ([jkeiser](https://github.com/jkeiser))
- Update Rakefile to avoid install-breaking bug [\#341](https://github.com/skywinder/github-changelog-generator/pull/341) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.4](https://github.com/skywinder/github-changelog-generator/tree/1.11.4) (2016-02-26)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.3...1.11.4)

**Merged pull requests:**

- Man page copying: only copy .1 [\#338](https://github.com/skywinder/github-changelog-generator/pull/338) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.3](https://github.com/skywinder/github-changelog-generator/tree/1.11.3) (2016-02-25)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.2...1.11.3)

**Closed issues:**

- Cannot install gem [\#335](https://github.com/skywinder/github-changelog-generator/issues/335)

## [1.11.2](https://github.com/skywinder/github-changelog-generator/tree/1.11.2) (2016-02-25)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.1...1.11.2)

**Fixed bugs:**

- Getting an error on install [\#329](https://github.com/skywinder/github-changelog-generator/issues/329)

**Merged pull requests:**

- Fix installation by not running the specs - which have dependencies [\#337](https://github.com/skywinder/github-changelog-generator/pull/337) ([skywinder](https://github.com/skywinder))

## [1.11.1](https://github.com/skywinder/github-changelog-generator/tree/1.11.1) (2016-02-25)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.11.0...1.11.1)

**Merged pull requests:**

- Add rubocop and rspec as runtime dependencies [\#336](https://github.com/skywinder/github-changelog-generator/pull/336) ([jkeiser](https://github.com/jkeiser))
- \[Refactor\] ParserFile class use Pathname [\#334](https://github.com/skywinder/github-changelog-generator/pull/334) ([olleolleolle](https://github.com/olleolleolle))
- \[Refactor\] Generator\#exclude\_issues\_by\_labels simpler, tested [\#332](https://github.com/skywinder/github-changelog-generator/pull/332) ([olleolleolle](https://github.com/olleolleolle))

## [1.11.0](https://github.com/skywinder/github-changelog-generator/tree/1.11.0) (2016-02-24)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.10.5...1.11.0)

## [1.10.5](https://github.com/skywinder/github-changelog-generator/tree/1.10.5) (2016-02-24)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.10.4...1.10.5)

## [1.10.4](https://github.com/skywinder/github-changelog-generator/tree/1.10.4) (2016-02-24)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.10.3...1.10.4)

**Fixed bugs:**

- Rake and Bundler as runtime deps [\#333](https://github.com/skywinder/github-changelog-generator/pull/333) ([olleolleolle](https://github.com/olleolleolle))

**Merged pull requests:**

- Test case for \#327 [\#331](https://github.com/skywinder/github-changelog-generator/pull/331) ([olleolleolle](https://github.com/olleolleolle))
- Fix crash installing on systems without overcommit [\#330](https://github.com/skywinder/github-changelog-generator/pull/330) ([jkeiser](https://github.com/jkeiser))

## [1.10.3](https://github.com/skywinder/github-changelog-generator/tree/1.10.3) (2016-02-23)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.10.2...1.10.3)

## [1.10.2](https://github.com/skywinder/github-changelog-generator/tree/1.10.2) (2016-02-23)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/v1.11.0...1.10.2)

## [v1.11.0](https://github.com/skywinder/github-changelog-generator/tree/v1.11.0) (2016-02-23)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.10.1...v1.11.0)

**Implemented enhancements:**

- YAML front matter [\#322](https://github.com/skywinder/github-changelog-generator/pull/322) ([retorquere](https://github.com/retorquere))
- Git Subcommand [\#288](https://github.com/skywinder/github-changelog-generator/pull/288) ([dlanileonardo](https://github.com/dlanileonardo))

**Fixed bugs:**

- detect\_since\_tag undefined [\#328](https://github.com/skywinder/github-changelog-generator/issues/328)

**Merged pull requests:**

- Update README.md [\#324](https://github.com/skywinder/github-changelog-generator/pull/324) ([Zearin](https://github.com/Zearin))

## [1.10.1](https://github.com/skywinder/github-changelog-generator/tree/1.10.1) (2016-01-06)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.10.0...1.10.1)

**Fixed bugs:**

- Parser: avoid Ruby exit, to make Rake tasks work [\#315](https://github.com/skywinder/github-changelog-generator/pull/315) ([olleolleolle](https://github.com/olleolleolle))

## [1.10.0](https://github.com/skywinder/github-changelog-generator/tree/1.10.0) (2016-01-05)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.9.0...1.10.0)

**Implemented enhancements:**

- Rubocop: less complex methods in parser.rb [\#297](https://github.com/skywinder/github-changelog-generator/pull/297) ([olleolleolle](https://github.com/olleolleolle))
- Introduce ParserError exception class [\#296](https://github.com/skywinder/github-changelog-generator/pull/296) ([olleolleolle](https://github.com/olleolleolle))
- ParserFile: support values with equals signs [\#285](https://github.com/skywinder/github-changelog-generator/pull/285) ([olleolleolle](https://github.com/olleolleolle))

**Closed issues:**

- PRs not closed on master branch show up in changelog [\#280](https://github.com/skywinder/github-changelog-generator/issues/280)

**Merged pull requests:**

- Update bundler [\#306](https://github.com/skywinder/github-changelog-generator/pull/306) ([SteveGilvarry](https://github.com/SteveGilvarry))
- Fixes \#280 Add release-branch option to filter the Pull Requests [\#305](https://github.com/skywinder/github-changelog-generator/pull/305) ([SteveGilvarry](https://github.com/SteveGilvarry))
- Add options to def self.user\_and\_project\_from\_git to fix parser.rb:19… [\#303](https://github.com/skywinder/github-changelog-generator/pull/303) ([SteveGilvarry](https://github.com/SteveGilvarry))
- Git ignore coverage/ [\#300](https://github.com/skywinder/github-changelog-generator/pull/300) ([olleolleolle](https://github.com/olleolleolle))
- \[refactor\] Fix docblock datatype, use \#map [\#299](https://github.com/skywinder/github-changelog-generator/pull/299) ([olleolleolle](https://github.com/olleolleolle))
- \[refactor\] Reader: positive Boolean; unused \#map [\#298](https://github.com/skywinder/github-changelog-generator/pull/298) ([olleolleolle](https://github.com/olleolleolle))
- Add base option to RakeTask [\#287](https://github.com/skywinder/github-changelog-generator/pull/287) ([jkeiser](https://github.com/jkeiser))

## [1.9.0](https://github.com/skywinder/github-changelog-generator/tree/1.9.0) (2015-09-17)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.8.5...1.9.0)

**Implemented enhancements:**

- Feature: exclude\_tags using regular expression [\#281](https://github.com/skywinder/github-changelog-generator/pull/281) ([olleolleolle](https://github.com/olleolleolle))
- Auto parse options from file .github\_changelog\_generator [\#278](https://github.com/skywinder/github-changelog-generator/pull/278) ([dlanileonardo](https://github.com/dlanileonardo))

## [1.8.5](https://github.com/skywinder/github-changelog-generator/tree/1.8.5) (2015-09-15)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.8.4...1.8.5)

**Merged pull requests:**

- Rake task: Be able to set false value in config [\#279](https://github.com/skywinder/github-changelog-generator/pull/279) ([olleolleolle](https://github.com/olleolleolle))

## [1.8.4](https://github.com/skywinder/github-changelog-generator/tree/1.8.4) (2015-09-01)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.8.3...1.8.4)

**Fixed bugs:**

- Sending OATH through -t fails [\#274](https://github.com/skywinder/github-changelog-generator/issues/274)

## [1.8.3](https://github.com/skywinder/github-changelog-generator/tree/1.8.3) (2015-08-31)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.8.2...1.8.3)

**Merged pull requests:**

- Do not alter pull\_requests while iterating on it [\#271](https://github.com/skywinder/github-changelog-generator/pull/271) ([raphink](https://github.com/raphink))

## [1.8.2](https://github.com/skywinder/github-changelog-generator/tree/1.8.2) (2015-08-26)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.8.1...1.8.2)

**Closed issues:**

- Output should not include security information [\#270](https://github.com/skywinder/github-changelog-generator/issues/270)

**Merged pull requests:**

- This PRi will fix \#274. [\#275](https://github.com/skywinder/github-changelog-generator/pull/275) ([skywinder](https://github.com/skywinder))

## [1.8.1](https://github.com/skywinder/github-changelog-generator/tree/1.8.1) (2015-08-25)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.8.0...1.8.1)

**Implemented enhancements:**

- Honor labels for Pull Requests [\#266](https://github.com/skywinder/github-changelog-generator/pull/266) ([raphink](https://github.com/raphink))

**Merged pull requests:**

- Fix issue with missing events \(in case of events for issue \>30\) [\#268](https://github.com/skywinder/github-changelog-generator/pull/268) ([skywinder](https://github.com/skywinder))
- Use since\_tag as default for older\_tag [\#267](https://github.com/skywinder/github-changelog-generator/pull/267) ([raphink](https://github.com/raphink))

## [1.8.0](https://github.com/skywinder/github-changelog-generator/tree/1.8.0) (2015-08-24)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.7.0...1.8.0)

**Implemented enhancements:**

- Generate change log since/due specific tag [\#254](https://github.com/skywinder/github-changelog-generator/issues/254)
- Add --base option [\#258](https://github.com/skywinder/github-changelog-generator/pull/258) ([raphink](https://github.com/raphink))

**Merged pull requests:**

- Add `--due-tag` option [\#265](https://github.com/skywinder/github-changelog-generator/pull/265) ([skywinder](https://github.com/skywinder))
- Add release\_url to rake task options [\#264](https://github.com/skywinder/github-changelog-generator/pull/264) ([raphink](https://github.com/raphink))
- Add a rake task [\#260](https://github.com/skywinder/github-changelog-generator/pull/260) ([raphink](https://github.com/raphink))
- Add release\_url option [\#259](https://github.com/skywinder/github-changelog-generator/pull/259) ([raphink](https://github.com/raphink))
- Add --since-tag [\#257](https://github.com/skywinder/github-changelog-generator/pull/257) ([raphink](https://github.com/raphink))

## [1.7.0](https://github.com/skywinder/github-changelog-generator/tree/1.7.0) (2015-07-16)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.6.2...1.7.0)

**Implemented enhancements:**

- Custom header [\#251](https://github.com/skywinder/github-changelog-generator/issues/251)
- Arbitrary templates [\#242](https://github.com/skywinder/github-changelog-generator/issues/242)

## [1.6.2](https://github.com/skywinder/github-changelog-generator/tree/1.6.2) (2015-07-16)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.6.1...1.6.2)

**Fixed bugs:**

- --unreleased-only broken [\#250](https://github.com/skywinder/github-changelog-generator/issues/250)

## [1.6.1](https://github.com/skywinder/github-changelog-generator/tree/1.6.1) (2015-06-12)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.6.0...1.6.1)

**Implemented enhancements:**

- Ability to specify custom section header [\#241](https://github.com/skywinder/github-changelog-generator/issues/241)

**Fixed bugs:**

- not encapsulated character `\<` [\#249](https://github.com/skywinder/github-changelog-generator/issues/249)

## [1.6.0](https://github.com/skywinder/github-changelog-generator/tree/1.6.0) (2015-06-11)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.5.0...1.6.0)

**Implemented enhancements:**

- Issues with any label  except "bug", "enhancement" should not be excluded by default. [\#240](https://github.com/skywinder/github-changelog-generator/issues/240)
- Add ability to specify custom labels for enhancements & bugfixes [\#54](https://github.com/skywinder/github-changelog-generator/issues/54)

**Fixed bugs:**

- --user and --project options are broken [\#246](https://github.com/skywinder/github-changelog-generator/issues/246)
- Exclude and Include tags is broken [\#245](https://github.com/skywinder/github-changelog-generator/issues/245)

## [1.5.0](https://github.com/skywinder/github-changelog-generator/tree/1.5.0) (2015-05-26)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.4.1...1.5.0)

**Implemented enhancements:**

- Show `Unreleased` section even when there is no tags in repo. [\#228](https://github.com/skywinder/github-changelog-generator/issues/228)
- Add option `--exclude-tags x,y,z` [\#214](https://github.com/skywinder/github-changelog-generator/issues/214)
- Generate change log between 2 specific tags [\#172](https://github.com/skywinder/github-changelog-generator/issues/172)
- Yanked releases support [\#53](https://github.com/skywinder/github-changelog-generator/issues/53)

**Merged pull requests:**

- Big refactoring [\#243](https://github.com/skywinder/github-changelog-generator/pull/243) ([skywinder](https://github.com/skywinder))

## [1.4.1](https://github.com/skywinder/github-changelog-generator/tree/1.4.1) (2015-05-19)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.4.0...1.4.1)

**Implemented enhancements:**

- Trees/Archives with missing change log notes for the current tag. [\#230](https://github.com/skywinder/github-changelog-generator/issues/230)

**Fixed bugs:**

- github\_changelog\_generator.rb:220:in ``': No such file or directory - pwd \(Errno::ENOENT\) [\#237](https://github.com/skywinder/github-changelog-generator/issues/237)
- Doesnot generator changelog [\#235](https://github.com/skywinder/github-changelog-generator/issues/235)
- Exclude closed \(not merged\) PR's from changelog. [\#69](https://github.com/skywinder/github-changelog-generator/issues/69)

**Merged pull requests:**

- Wrap GitHub requests in function check\_github\_response [\#238](https://github.com/skywinder/github-changelog-generator/pull/238) ([skywinder](https://github.com/skywinder))
- Add fetch token tests [\#236](https://github.com/skywinder/github-changelog-generator/pull/236) ([skywinder](https://github.com/skywinder))
- Add future release option [\#231](https://github.com/skywinder/github-changelog-generator/pull/231) ([sildur](https://github.com/sildur))

## [1.4.0](https://github.com/skywinder/github-changelog-generator/tree/1.4.0) (2015-05-07)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.11...1.4.0)

**Implemented enhancements:**

- Parsing of existing Change Log file [\#212](https://github.com/skywinder/github-changelog-generator/issues/212)
- Warn users about 0 tags in repo. [\#208](https://github.com/skywinder/github-changelog-generator/issues/208)
- Cleanup [\#220](https://github.com/skywinder/github-changelog-generator/pull/220) ([tuexss](https://github.com/tuexss))

**Closed issues:**

- Add CodeClimate and Inch CI [\#219](https://github.com/skywinder/github-changelog-generator/issues/219)

**Merged pull requests:**

- Implement fetcher class [\#227](https://github.com/skywinder/github-changelog-generator/pull/227) ([skywinder](https://github.com/skywinder))
- Add coveralls integration [\#223](https://github.com/skywinder/github-changelog-generator/pull/223) ([skywinder](https://github.com/skywinder))
- Rspec & rubocop integration [\#217](https://github.com/skywinder/github-changelog-generator/pull/217) ([skywinder](https://github.com/skywinder))
- Implement Reader class to parse ChangeLog.md [\#216](https://github.com/skywinder/github-changelog-generator/pull/216) ([estahn](https://github.com/estahn))
- Relatively require github\_changelog\_generator library [\#207](https://github.com/skywinder/github-changelog-generator/pull/207) ([sneal](https://github.com/sneal))
- Add --max-issues argument to limit requests [\#76](https://github.com/skywinder/github-changelog-generator/pull/76) ([sneal](https://github.com/sneal))

## [1.3.11](https://github.com/skywinder/github-changelog-generator/tree/1.3.11) (2015-03-21)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.10...1.3.11)

**Merged pull requests:**

- Add  fallback with warning message to prevent crash in case of exceed API Rate Limit \(temporary workaround for \#71\) [\#75](https://github.com/skywinder/github-changelog-generator/pull/75) ([skywinder](https://github.com/skywinder))

## [1.3.10](https://github.com/skywinder/github-changelog-generator/tree/1.3.10) (2015-03-18)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.9...1.3.10)

**Fixed bugs:**

- Fix termination in case of empty unreleased section with `--unreleased-only` option. [\#70](https://github.com/skywinder/github-changelog-generator/pull/70) ([skywinder](https://github.com/skywinder))

## [1.3.9](https://github.com/skywinder/github-changelog-generator/tree/1.3.9) (2015-03-06)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.8...1.3.9)

**Implemented enhancements:**

- Improve method of detecting owner and repository [\#63](https://github.com/skywinder/github-changelog-generator/issues/63)

**Fixed bugs:**

- Resolved concurrency problem in case of issues \> 2048 [\#65](https://github.com/skywinder/github-changelog-generator/pull/65) ([skywinder](https://github.com/skywinder))

## [1.3.8](https://github.com/skywinder/github-changelog-generator/tree/1.3.8) (2015-03-05)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.6...1.3.8)

## [1.3.6](https://github.com/skywinder/github-changelog-generator/tree/1.3.6) (2015-03-05)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.5...1.3.6)

## [1.3.5](https://github.com/skywinder/github-changelog-generator/tree/1.3.5) (2015-03-04)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.4...1.3.5)

**Fixed bugs:**

- Pull Requests in Wrong Tag [\#60](https://github.com/skywinder/github-changelog-generator/issues/60)

## [1.3.4](https://github.com/skywinder/github-changelog-generator/tree/1.3.4) (2015-03-03)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.3...1.3.4)

**Fixed bugs:**

- --no-issues appears to break PRs [\#59](https://github.com/skywinder/github-changelog-generator/issues/59)

## [1.3.3](https://github.com/skywinder/github-changelog-generator/tree/1.3.3) (2015-03-03)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.2...1.3.3)

**Closed issues:**

- Add \# character to encapsulate list. [\#58](https://github.com/skywinder/github-changelog-generator/issues/58)

## [1.3.2](https://github.com/skywinder/github-changelog-generator/tree/1.3.2) (2015-03-03)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.1...1.3.2)

**Fixed bugs:**

- generation failed if github commit api return `404 Not Found` [\#57](https://github.com/skywinder/github-changelog-generator/issues/57)

## [1.3.1](https://github.com/skywinder/github-changelog-generator/tree/1.3.1) (2015-02-27)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.3.0...1.3.1)

## [1.3.0](https://github.com/skywinder/github-changelog-generator/tree/1.3.0) (2015-02-26)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.8...1.3.0)

**Implemented enhancements:**

- Do not show `Unreleased` section, when it's empty. [\#55](https://github.com/skywinder/github-changelog-generator/issues/55)
- Separate list exclude and include labels [\#52](https://github.com/skywinder/github-changelog-generator/issues/52)
- Unreleased issues in separate section [\#47](https://github.com/skywinder/github-changelog-generator/issues/47)
- Separate by lists: Enhancements, Bugs, Pull requests. [\#31](https://github.com/skywinder/github-changelog-generator/issues/31)

**Fixed bugs:**

- Pull request with invalid label \(\#26\) in changelog appeared. [\#44](https://github.com/skywinder/github-changelog-generator/issues/44)

**Merged pull requests:**

- Implement filtering of Pull Requests by milestones [\#50](https://github.com/skywinder/github-changelog-generator/pull/50) ([skywinder](https://github.com/skywinder))

## [1.2.8](https://github.com/skywinder/github-changelog-generator/tree/1.2.8) (2015-02-17)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.7...1.2.8)

**Closed issues:**

- Bugs, that closed simultaneously with push not appeared in correct version. [\#37](https://github.com/skywinder/github-changelog-generator/issues/37)

**Merged pull requests:**

- Feature/fix 37 [\#49](https://github.com/skywinder/github-changelog-generator/pull/49) ([skywinder](https://github.com/skywinder))
- Prettify output [\#48](https://github.com/skywinder/github-changelog-generator/pull/48) ([skywinder](https://github.com/skywinder))

## [1.2.7](https://github.com/skywinder/github-changelog-generator/tree/1.2.7) (2015-01-26)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.6...1.2.7)

**Implemented enhancements:**

- Add compare link between older version and newer version [\#46](https://github.com/skywinder/github-changelog-generator/pull/46) ([sue445](https://github.com/sue445))

## [1.2.6](https://github.com/skywinder/github-changelog-generator/tree/1.2.6) (2015-01-21)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.5...1.2.6)

**Merged pull requests:**

- fix link tag format [\#45](https://github.com/skywinder/github-changelog-generator/pull/45) ([sugamasao](https://github.com/sugamasao))

## [1.2.5](https://github.com/skywinder/github-changelog-generator/tree/1.2.5) (2015-01-15)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.4...1.2.5)

**Implemented enhancements:**

- Use milestone to specify in which version bug was fixed [\#22](https://github.com/skywinder/github-changelog-generator/issues/22)
- support enterprise github via command line options [\#42](https://github.com/skywinder/github-changelog-generator/pull/42) ([glenlovett](https://github.com/glenlovett))

**Fixed bugs:**

- Error when trying to generate log for repo without tags [\#32](https://github.com/skywinder/github-changelog-generator/issues/32)
- PrettyPrint class is included using lowercase 'pp' [\#43](https://github.com/skywinder/github-changelog-generator/pull/43) ([schwing](https://github.com/schwing))

## [1.2.4](https://github.com/skywinder/github-changelog-generator/tree/1.2.4) (2014-12-16)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.3...1.2.4)

**Fixed bugs:**

- Sometimes user is NULL during merges [\#41](https://github.com/skywinder/github-changelog-generator/issues/41)
- Crash when try generate log for rails [\#35](https://github.com/skywinder/github-changelog-generator/issues/35)

## [1.2.3](https://github.com/skywinder/github-changelog-generator/tree/1.2.3) (2014-12-16)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.2...1.2.3)

**Implemented enhancements:**

- Add ability to run with one parameter instead -u -p [\#38](https://github.com/skywinder/github-changelog-generator/issues/38)
- Detailed output [\#33](https://github.com/skywinder/github-changelog-generator/issues/33)

**Fixed bugs:**

- Docs lacking or basic behavior not as advertised [\#30](https://github.com/skywinder/github-changelog-generator/issues/30)

**Merged pull requests:**

- Implement async fetching [\#39](https://github.com/skywinder/github-changelog-generator/pull/39) ([skywinder](https://github.com/skywinder))
- Fix crash when user is NULL [\#40](https://github.com/skywinder/github-changelog-generator/pull/40) ([skywinder](https://github.com/skywinder))

## [1.2.2](https://github.com/skywinder/github-changelog-generator/tree/1.2.2) (2014-12-10)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.1...1.2.2)

**Fixed bugs:**

- Encapsulate \[ \> \* \_ \ \] signs in issues names [\#34](https://github.com/skywinder/github-changelog-generator/issues/34)

## [1.2.1](https://github.com/skywinder/github-changelog-generator/tree/1.2.1) (2014-11-22)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.2.0...1.2.1)

**Fixed bugs:**

- Script fills changelog only for first 30 tags. [\#20](https://github.com/skywinder/github-changelog-generator/issues/20)

**Merged pull requests:**

- Issues for last tag not in list [\#29](https://github.com/skywinder/github-changelog-generator/pull/29) ([skywinder](https://github.com/skywinder))
- Disable default --filter-pull-requests option. [\#28](https://github.com/skywinder/github-changelog-generator/pull/28) ([skywinder](https://github.com/skywinder))

## [1.2.0](https://github.com/skywinder/github-changelog-generator/tree/1.2.0) (2014-11-19)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.1.4...1.2.0)

**Merged pull requests:**

- Add filter for pull-requests labels. \(option --filter-pull-requests\) [\#27](https://github.com/skywinder/github-changelog-generator/pull/27) ([skywinder](https://github.com/skywinder))
- Add ability to insert authors of pull-requests \(--\[no-\]author option\) [\#25](https://github.com/skywinder/github-changelog-generator/pull/25) ([skywinder](https://github.com/skywinder))
- Don't receive issues in case of --no-isses flag specied [\#24](https://github.com/skywinder/github-changelog-generator/pull/24) ([skywinder](https://github.com/skywinder))

## [1.1.4](https://github.com/skywinder/github-changelog-generator/tree/1.1.4) (2014-11-18)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.1.2...1.1.4)

**Implemented enhancements:**

- Implement ability to retrieve GitHub token from ENV variable \(to not put it to script directly\) [\#19](https://github.com/skywinder/github-changelog-generator/issues/19)

**Merged pull requests:**

- Sort tags by date [\#23](https://github.com/skywinder/github-changelog-generator/pull/23) ([skywinder](https://github.com/skywinder))

## [1.1.2](https://github.com/skywinder/github-changelog-generator/tree/1.1.2) (2014-11-12)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.1.1...1.1.2)

**Merged pull requests:**

- Fix bug with dot signs in project name [\#18](https://github.com/skywinder/github-changelog-generator/pull/18) ([skywinder](https://github.com/skywinder))
- Fix bug with dot signs in user name [\#17](https://github.com/skywinder/github-changelog-generator/pull/17) ([skywinder](https://github.com/skywinder))

## [1.1.1](https://github.com/skywinder/github-changelog-generator/tree/1.1.1) (2014-11-10)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.1.0...1.1.1)

**Merged pull requests:**

- Remove duplicates of issues and pull-requests with same number [\#15](https://github.com/skywinder/github-changelog-generator/pull/15) ([skywinder](https://github.com/skywinder))
- Sort issues by tags [\#14](https://github.com/skywinder/github-changelog-generator/pull/14) ([skywinder](https://github.com/skywinder))
- Add ability to add or exclude issues without any labels [\#13](https://github.com/skywinder/github-changelog-generator/pull/13) ([skywinder](https://github.com/skywinder))

## [1.1.0](https://github.com/skywinder/github-changelog-generator/tree/1.1.0) (2014-11-10)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.0.1...1.1.0)

**Implemented enhancements:**

- Detect username and project form origin [\#11](https://github.com/skywinder/github-changelog-generator/issues/11)

**Fixed bugs:**

- Bug with wrong credentials in 1.0.1 [\#12](https://github.com/skywinder/github-changelog-generator/issues/12)
- Markdown formating in the last line wrong [\#9](https://github.com/skywinder/github-changelog-generator/issues/9)

## [1.0.1](https://github.com/skywinder/github-changelog-generator/tree/1.0.1) (2014-11-10)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/skywinder/github-changelog-generator/tree/1.0.0) (2014-11-07)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/0.1.0...1.0.0)

**Implemented enhancements:**

- Add support for fixed issues and implemented enchanments. [\#6](https://github.com/skywinder/github-changelog-generator/issues/6)
- Implement option to specify output filename [\#4](https://github.com/skywinder/github-changelog-generator/issues/4)
- Implement support of different tags. [\#8](https://github.com/skywinder/github-changelog-generator/pull/8) ([skywinder](https://github.com/skywinder))

**Fixed bugs:**

- Last tag not appeared in changelog [\#5](https://github.com/skywinder/github-changelog-generator/issues/5)

**Merged pull requests:**

- Add support for issues in CHANGELOG [\#7](https://github.com/skywinder/github-changelog-generator/pull/7) ([skywinder](https://github.com/skywinder))

## [0.1.0](https://github.com/skywinder/github-changelog-generator/tree/0.1.0) (2014-11-07)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/0.0.2...0.1.0)

**Merged pull requests:**

- Fix parsing date of pull request [\#3](https://github.com/skywinder/github-changelog-generator/pull/3) ([skywinder](https://github.com/skywinder))
- Add changelog generation for last tag [\#2](https://github.com/skywinder/github-changelog-generator/pull/2) ([skywinder](https://github.com/skywinder))
- Add option \(-o --output\) to specify name of the output file. [\#1](https://github.com/skywinder/github-changelog-generator/pull/1) ([skywinder](https://github.com/skywinder))

## [0.0.2](https://github.com/skywinder/github-changelog-generator/tree/0.0.2) (2014-11-06)
[Full Changelog](https://github.com/skywinder/github-changelog-generator/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/skywinder/github-changelog-generator/tree/0.0.1) (2014-11-06)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*