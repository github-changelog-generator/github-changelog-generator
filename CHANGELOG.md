# Change Log

## [Unreleased](https://github.com/skywinder/Github-Changelog-Generator/tree/HEAD)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.11...HEAD)

- Parsing of existing Change Log file [\#212](https://github.com/skywinder/github-changelog-generator/issues/212)

- Warn users about 0 tags in repo. [\#208](https://github.com/skywinder/github-changelog-generator/issues/208)

- Add CodeClimate and Inch CI [\#219](https://github.com/skywinder/github-changelog-generator/issues/219)

- Cleanup [\#220](https://github.com/skywinder/github-changelog-generator/pull/220) ([tuexss](https://github.com/tuexss))

- Add coveralls integration [\#223](https://github.com/skywinder/github-changelog-generator/pull/223) ([skywinder](https://github.com/skywinder))

- Rspec & rubocop integration [\#217](https://github.com/skywinder/github-changelog-generator/pull/217) ([skywinder](https://github.com/skywinder))

- Implement Reader class to parse ChangeLog.md [\#216](https://github.com/skywinder/github-changelog-generator/pull/216) ([estahn](https://github.com/estahn))

- Relatively require github\_changelog\_generator library [\#207](https://github.com/skywinder/github-changelog-generator/pull/207) ([sneal](https://github.com/sneal))

- Add --max-issues argument to limit requests [\#76](https://github.com/skywinder/github-changelog-generator/pull/76) ([sneal](https://github.com/sneal))

## [1.3.11](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.11) (2015-03-21)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.10...1.3.11)

- Add  fallback with warning message to prevent crash in case of exceed API Rate Limit \(temporary workaround for \#71\) [\#75](https://github.com/skywinder/github-changelog-generator/pull/75) ([skywinder](https://github.com/skywinder))

## [1.3.10](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.10) (2015-03-18)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.9...1.3.10)

- Exclude closed \(not merged\) PR's from changelog. [\#69](https://github.com/skywinder/github-changelog-generator/issues/69)

- Fix termination in case of empty unreleased section with `--unreleased-only` option. [\#70](https://github.com/skywinder/github-changelog-generator/pull/70) ([skywinder](https://github.com/skywinder))

## [1.3.9](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.9) (2015-03-06)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.8...1.3.9)

- Improve method of detecting owner and repository [\#63](https://github.com/skywinder/github-changelog-generator/issues/63)

- Resolved concurrency problem in case of issues \> 2048 [\#65](https://github.com/skywinder/github-changelog-generator/pull/65) ([skywinder](https://github.com/skywinder))

## [1.3.8](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.8) (2015-03-05)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.6...1.3.8)

- Fix `git remote` parsing in case, when script running without parameters inside destination directory [\#61](https://github.com/skywinder/github-changelog-generator/pull/61) ([skywinder](https://github.com/skywinder))

## [1.3.6](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.6) (2015-03-05)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.5...1.3.6)

## [1.3.5](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.5) (2015-03-04)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.4...1.3.5)

- Pull Requests in Wrong Tag [\#60](https://github.com/skywinder/github-changelog-generator/issues/60)

## [1.3.4](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.4) (2015-03-03)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.3...1.3.4)

- --no-issues appears to break PRs [\#59](https://github.com/skywinder/github-changelog-generator/issues/59)

## [1.3.3](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.3) (2015-03-03)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.2...1.3.3)

- Add \# character to encapsulate list. [\#58](https://github.com/skywinder/github-changelog-generator/issues/58)

## [1.3.2](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.2) (2015-03-03)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.1...1.3.2)

- generation failed if github commit api return `404 Not Found` [\#57](https://github.com/skywinder/github-changelog-generator/issues/57)

## [1.3.1](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.1) (2015-02-27)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.3.0...1.3.1)

## [1.3.0](https://github.com/skywinder/Github-Changelog-Generator/tree/1.3.0) (2015-02-26)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.8...1.3.0)

- Do not show `Unreleased` section, when it's empty. [\#55](https://github.com/skywinder/github-changelog-generator/issues/55)

- Separate list exclude and include labels [\#52](https://github.com/skywinder/github-changelog-generator/issues/52)

- Unreleased issues in separate section [\#47](https://github.com/skywinder/github-changelog-generator/issues/47)

- Separate by lists: Enhancements, Bugs, Pull requests. [\#31](https://github.com/skywinder/github-changelog-generator/issues/31)

- Pull request with invalid label \(\#26\) in changelog appeared. [\#44](https://github.com/skywinder/github-changelog-generator/issues/44)

- Implement filtering of Pull Requests by milestones [\#50](https://github.com/skywinder/github-changelog-generator/pull/50) ([skywinder](https://github.com/skywinder))

## [1.2.8](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.8) (2015-02-17)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.7...1.2.8)

- Bugs, that closed simultaneously with push not appeared in correct version. [\#37](https://github.com/skywinder/github-changelog-generator/issues/37)

- Feature/fix 37 [\#49](https://github.com/skywinder/github-changelog-generator/pull/49) ([skywinder](https://github.com/skywinder))

- Prettify output [\#48](https://github.com/skywinder/github-changelog-generator/pull/48) ([skywinder](https://github.com/skywinder))

## [1.2.7](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.7) (2015-01-26)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.6...1.2.7)

- Add compare link between older version and newer version [\#46](https://github.com/skywinder/github-changelog-generator/pull/46) ([sue445](https://github.com/sue445))

## [1.2.6](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.6) (2015-01-21)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.5...1.2.6)

- fix link tag format [\#45](https://github.com/skywinder/github-changelog-generator/pull/45) ([sugamasao](https://github.com/sugamasao))

## [1.2.5](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.5) (2015-01-15)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.4...1.2.5)

- Use milestone to specify in which version bug was fixed [\#22](https://github.com/skywinder/github-changelog-generator/issues/22)

- Error when trying to generate log for repo without tags [\#32](https://github.com/skywinder/github-changelog-generator/issues/32)

- PrettyPrint class is included using lowercase 'pp' [\#43](https://github.com/skywinder/github-changelog-generator/pull/43) ([schwing](https://github.com/schwing))

- support enterprise github via command line options [\#42](https://github.com/skywinder/github-changelog-generator/pull/42) ([glenlovett](https://github.com/glenlovett))

## [1.2.4](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.4) (2014-12-16)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.3...1.2.4)

- Sometimes user is NULL during merges [\#41](https://github.com/skywinder/github-changelog-generator/issues/41)

- Crash when try generate log for rails [\#35](https://github.com/skywinder/github-changelog-generator/issues/35)

## [1.2.3](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.3) (2014-12-16)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.2...1.2.3)

- Add ability to run with one parameter instead -u -p [\#38](https://github.com/skywinder/github-changelog-generator/issues/38)

- Detailed output [\#33](https://github.com/skywinder/github-changelog-generator/issues/33)

- Docs lacking or basic behavior not as advertised [\#30](https://github.com/skywinder/github-changelog-generator/issues/30)

- Implement async fetching [\#39](https://github.com/skywinder/github-changelog-generator/pull/39) ([skywinder](https://github.com/skywinder))

- Fix crash when user is NULL [\#40](https://github.com/skywinder/github-changelog-generator/pull/40) ([skywinder](https://github.com/skywinder))

## [1.2.2](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.2) (2014-12-10)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.1...1.2.2)

- Encapsulate \[ \> \* \_ \ \] signs in issues names [\#34](https://github.com/skywinder/github-changelog-generator/issues/34)

- Add a Bitdeli Badge to README [\#36](https://github.com/skywinder/github-changelog-generator/pull/36) ([bitdeli-chef](https://github.com/bitdeli-chef))

## [1.2.1](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.1) (2014-11-22)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.2.0...1.2.1)

- Script fills changelog only for first 30 tags. [\#20](https://github.com/skywinder/github-changelog-generator/issues/20)

- Issues for last tag not in list [\#29](https://github.com/skywinder/github-changelog-generator/pull/29) ([skywinder](https://github.com/skywinder))

- Disable default --filter-pull-requests option. [\#28](https://github.com/skywinder/github-changelog-generator/pull/28) ([skywinder](https://github.com/skywinder))

## [1.2.0](https://github.com/skywinder/Github-Changelog-Generator/tree/1.2.0) (2014-11-19)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.1.4...1.2.0)

- Add filter for pull-requests labels. \(option --filter-pull-requests\) [\#27](https://github.com/skywinder/github-changelog-generator/pull/27) ([skywinder](https://github.com/skywinder))

- Add ability to insert authors of pull-requests \(--\[no-\]author option\) [\#25](https://github.com/skywinder/github-changelog-generator/pull/25) ([skywinder](https://github.com/skywinder))

- Don't receive issues in case of --no-isses flag specied [\#24](https://github.com/skywinder/github-changelog-generator/pull/24) ([skywinder](https://github.com/skywinder))

## [1.1.4](https://github.com/skywinder/Github-Changelog-Generator/tree/1.1.4) (2014-11-18)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.1.2...1.1.4)

- Implement ability to retrieve GitHub token from ENV variable \(to not put it to script directly\) [\#19](https://github.com/skywinder/github-changelog-generator/issues/19)

- Sort tags by date [\#23](https://github.com/skywinder/github-changelog-generator/pull/23) ([skywinder](https://github.com/skywinder))

## [1.1.2](https://github.com/skywinder/Github-Changelog-Generator/tree/1.1.2) (2014-11-12)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.1.1...1.1.2)

- Fix bug with dot signs in project name [\#18](https://github.com/skywinder/github-changelog-generator/pull/18) ([skywinder](https://github.com/skywinder))

- Fix bug with dot signs in user name [\#17](https://github.com/skywinder/github-changelog-generator/pull/17) ([skywinder](https://github.com/skywinder))

## [1.1.1](https://github.com/skywinder/Github-Changelog-Generator/tree/1.1.1) (2014-11-10)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.1.0...1.1.1)

- Remove duplicates of issues and pull-requests with same number [\#15](https://github.com/skywinder/github-changelog-generator/pull/15) ([skywinder](https://github.com/skywinder))

- Sort issues by tags [\#14](https://github.com/skywinder/github-changelog-generator/pull/14) ([skywinder](https://github.com/skywinder))

- Add ability to add or exclude issues without any labels [\#13](https://github.com/skywinder/github-changelog-generator/pull/13) ([skywinder](https://github.com/skywinder))

## [1.1.0](https://github.com/skywinder/Github-Changelog-Generator/tree/1.1.0) (2014-11-10)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.0.1...1.1.0)

- Detect username and project form origin [\#11](https://github.com/skywinder/github-changelog-generator/issues/11)

- Bug with wrong credentials in 1.0.1 [\#12](https://github.com/skywinder/github-changelog-generator/issues/12)

- Markdown formating in the last line wrong [\#9](https://github.com/skywinder/github-changelog-generator/issues/9)

## [1.0.1](https://github.com/skywinder/Github-Changelog-Generator/tree/1.0.1) (2014-11-10)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/skywinder/Github-Changelog-Generator/tree/1.0.0) (2014-11-07)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/0.1.0...1.0.0)

- Add support for fixed issues and implemented enchanments. [\#6](https://github.com/skywinder/github-changelog-generator/issues/6)

- Implement option to specify output filename [\#4](https://github.com/skywinder/github-changelog-generator/issues/4)

- Last tag not appeared in changelog [\#5](https://github.com/skywinder/github-changelog-generator/issues/5)

- Implement support of different tags. [\#8](https://github.com/skywinder/github-changelog-generator/pull/8) ([skywinder](https://github.com/skywinder))

- Add support for issues in CHANGELOG [\#7](https://github.com/skywinder/github-changelog-generator/pull/7) ([skywinder](https://github.com/skywinder))

## [0.1.0](https://github.com/skywinder/Github-Changelog-Generator/tree/0.1.0) (2014-11-07)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/0.0.2...0.1.0)

- Fix parsing date of pull request [\#3](https://github.com/skywinder/github-changelog-generator/pull/3) ([skywinder](https://github.com/skywinder))

- Add changelog generation for last tag [\#2](https://github.com/skywinder/github-changelog-generator/pull/2) ([skywinder](https://github.com/skywinder))

- Add option \(-o --output\) to specify name of the output file. [\#1](https://github.com/skywinder/github-changelog-generator/pull/1) ([skywinder](https://github.com/skywinder))

## [0.0.2](https://github.com/skywinder/Github-Changelog-Generator/tree/0.0.2) (2014-11-06)

[Full Changelog](https://github.com/skywinder/Github-Changelog-Generator/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/skywinder/Github-Changelog-Generator/tree/0.0.1) (2014-11-06)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*