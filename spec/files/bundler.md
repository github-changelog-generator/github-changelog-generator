## 1.9.1 (2015-03-21)

Bugfixes:

  - avoid exception in 'bundler/gem_tasks' (#3492, @segiddins)

## 1.9.0 (2015-03-20)

## 1.9.0.rc (2015-03-13)

Bugfixes:

  - make Bundler.which stop finding directories (@nohoho)
  - handle Bundler prereleases correctly (#3470, @segiddins)
  - add before_install to .travis.yml template for new gems (@kodnin)

## 1.9.0.pre.1 (2015-03-11)

Bugfixes:

  - make `gem` command work again (@arthurnn)

## 1.9.0.pre (2015-03-11)

Features:

  - prefer gemspecs closest to the directory root (#3428, @segiddins)
  - debug log for API request limits (#3452, @neerfri)

"Features":

  - Molinillo resolver, shared with CocoaPods (@segiddins)
  - updated Thor to v0.19.1 (@segiddins)

## 1.8.5 (2015-03-11)

Bugfixes:

  - remove MIT license from gemspec when removing license file (@indirect)
  - respect 'no' immediately as well as saving it in `gem` config (@kirs)

## 1.8.4 (2015-03-05)

Bugfixes:

  - document --all-platforms option (#3449, @moeffju)
  - find gems from all sources on exec after install (#3450, @TimMoore)

## 1.8.3 (2015-02-24)

Bugfixes:

  - handle boolean values for gem settings (@EduardoBautista)
  - stop always looking for updated `path` gems (#3414, #3417, #3429, @TimMoore)

## 1.8.2 (2015-02-14)

Bugfixes:

  - allow config settings for gems with 'http' in the name again (#3398, @TimMoore)

## 1.8.1 (2015-02-13)

Bugfixes:

  - synchronize building git gem native extensions (#3385, @antifuchs & @indirect)
  - set gemspec bindir correctly (#3392, @TimMoore)
  - request lockfile deletion when it is malformed (#3396, @indirect)
  - explain problem when mirror config is missing (#3386, @indirect)
  - explain problem when caching causes permission error (#3390, @indirect)
  - normalize URLs in config keys (#3391, @indirect)

## 1.8.0 (2015-02-10)

Bugfixes:

  - gemfile `github` blocks now work (#3379, @indirect)

Bugfixes from v1.7.13:

  - look up installed gems in remote sources (#3300, #3368, #3377, #3380, #3381, @indirect)
  - look up gems across all sources to satisfy dependencies (#3365, @keiths-osc)
  - request dependencies for no more than 100 gems at a time (#3367, @segiddins)

## 1.8.0.rc (2015-01-26)

Features:

  - add `config disable_multisource` option to ensure sources can't compete (@indirect)

Bugfixes:

  - don't add extra quotes around long, quoted config values (@aroben, #3338)

Security:

  - warn when more than one top-level source is present (@indirect)

## 1.8.0.pre (2015-01-26)

Features:

  - add metadata allowed_push_host to new gem template (#3002, @juanitofatas)
  - adds a `--no-install` flag to `bundle package` (@d-reinhold)
  - add `bundle config auto_install true` to install automatically (@smashwilson)
  - add `bundle viz --without` to exclude gem groups from resulting graph (@fnichol)
  - prevent whitespace in gem declarations with clear messaging (@benlakey)
  - tries to find a `bundler-<command>` executable on your path for non-bundler commands (@andremedeiros)
  - tries to find `gems.rb` and it's new counterpart, `gems.locked` (@andremedeiros)
  - change the initial version of new gems from `0.0.1` to `0.1.0` (@petedmarsh)
  - add `package --all-platforms` to cache gems for each known platform (@ccutrer)
  - speed up `exec` when running commands on the $PATH (@kirs)
  - add gem code of conduct file and option (@kirs)
  - add config settings for gem license and tests (@kirs)
  - add `bin/setup` and `bin/console` to new gems (@indirect)
  - include configured user-agent in network requests (@indirect)
  - support `github`, `gist`, and `bitbucket` options on git gems (@indirect)
  - add `package --cache-path` and `config cache_path` for cache location (@jnraine)
  - allow `config` to work even when a Gemfile is not present (@dholdren)
  - add `config gemfile /path` for other Gemfile locations (@dholdren)
  - add `github` method alonside the `git` method (@BenMorganIO)

Bugfixes:

  - reduce memory usage with threaded parallel workers (@Who828)
  - support read-only git gems (@pmahoney)
  - various resolver performance improvements (@dubek)
  - untaint git gem paths for Rubygems compatibility (@tdtds)

Documentation:

  - add missing Gemfile global `path` explanation (@agenteo)

## 1.7.13 (2015-02-07)

Bugfixes:

  - Look up installed gems in remote sources (#3300, #3368, #3377, #3380, #3381, @indirect)
  - Look up gems across all sources to satisfy dependencies (#3365, @keiths-osc)
  - Request dependencies for no more than 100 gems at a time (#3367, @segiddins)

## 1.7.12 (2015-01-08)

Bugfixes:

  - Always send credentials for sources, fixing private Gemfury gems (#3342, @TimMoore)

## 1.7.11 (2015-01-04)

Bugfixes:

  - Recognize `:mri_22` and `:mingw_22`, rather than just `:ruby_22` (#3328, @myabc)

## 1.7.10 (2014-12-29)

Bugfixes:

  - Fix source blocks sometimes causing deployment mode to fail wrongly (#3298, @TimMoore)

Features(?):

  - Support `platform :mri_22` and related version bits (#3309, @thomasfedb)

## 1.7.9 (2014-12-09)

Bugfixes:

  - Fix an issue where bundler sometime spams one gem in Gemfile.lock (#3216, @Who828)
  - Ensure bundle update installs the newer version of the gem (#3089, @Who828)
  - Fix an regression which stopped Bundler from resolving some Gemfiles (#3059, #3248, @Who828)

## 1.7.8 (2014-12-06)

Bugfixes:

  - Hide credentials while warning about gems with ambiguous sources (#3256, @TimMoore)

## 1.7.7 (2014-11-19)

Bugfixes:

  - Ensure server credentials stored in config or ENV will be used (#3180, @arronmabrey)
  - Fix race condition causing errors while installing git-based gems (#3174, @Who828)
  - Use single quotes in config so YAML won't add more quotes (#3261, @indirect)

## 1.7.6 (2014-11-11)

Bugfixes:

  - CA certificates that work with all OpenSSLs (@luislavena, @indirect)

## 1.7.5 (2014-11-10)

Bugfixes:

  - Fix --deployment with source blocks and non-alphabetical gems (#3224, @TimMoore)
  - Vendor CA chain to validate new rubygems.org HTTPS certificate (@indirect)

## 1.7.4 (2014-10-19)

Bugfixes:

  - Allow --deployment after `pack` while using source blocks (#3167, @TimMoore)
  - Use dependency API even when HTTP credentials are in ENV (#3191, @fvaleur)
  - Silence warnings (including root warning) in --quiet mode (#3186, @indirect)
  - Stop asking gem servers for gems already found locally (#2909, @dubek)

## 1.7.3 (2014-09-14)

Bugfixes:

  - `extconf.rb` is now generated with the right path for `create_makefile` (@andremedeiros)
  - Fix various Ruby warnings (@piotrsanarki, @indirect)

## 1.7.2 (2014-08-23)

Bugfixes:

  - Revert gem source sorting in lock files (@indirect)

## 1.7.1 (2014-08-20)

Bugfixes:

  - Install gems from one source needed by gems in another source (@indirect)
  - Install the same gem versions even after some are installed (@TimMoore)
  - Download specs only when installing from servers (@indirect)

## 1.7.0 (2014-08-13)

Security:

  - Fix for CVE-2013-0334, installing gems from an unexpected source (@TimMoore)

Features:

  - Gemfile `source` calls now take a block containing gems from that source (@TimMoore)
  - Added the `:source` option to `gem` to specify a source (@TimMoore)

Bugfixes:

  - Warn on ambiguous gems available from more than one source (@TimMoore)

## 1.6.7 (2014-10-19)

Features:

  - warn to upgrade when using useless source blocks (@danfinnie)

Documentation:

  - explain how to use gem server credentials via ENV (@hwartig)

## 1.6.6 (2014-08-23)

Bugfixes:

  - restore Gemfile credentials to Gemfile.lock (@indirect)

## 1.6.5 (2014-07-23)

Bugfixes:

  - require openssl explicitly to fix rare HTTPS request failures (@indirect, #3107)

## 1.6.4 (2014-07-17)

Bugfixes:

  - fix undefined constant error when can't find gem during binstubs (#3095, @jetaggart)
  - work when installed git gems are not writable (#3092, @pmahoney)
  - don't store configured source credentials in Gemfile.lock (#3045, @lhz)
  - don't include config source credentials in the lockfile (Lars Haugseth)
  - use threads for jobs on Rubinius (@YorickPeterse)
  - skip dependencies from other platforms (@mvz)
  - work when Rubygems was built without SSL (@andremedeiros)

## 1.6.3 (2014-06-16)

Bugfixes:

  - fix regression when resolving many conflicts (#2994, @Who828)
  - use local gemspec for builtin gems during install --local (#3041, @Who828)
  - don't warn about sudo when installing on Windows (#2984, @indirect)
  - shell escape `bundle open` arguments (@indirect)

## 1.6.2 (2014-04-13)

Bugfixes:

  - fix an exception when using builtin gems (#2915, #2963, @gnufied)
  - cache gems that are built in to the running ruby (#2975, @indirect)
  - re-allow deploying cached git gems without git installed (#2968, @aughr)
  - keep standalone working even with builtin gems (@indirect)
  - don't update vendor/cache in deployment mode (#2921, @indirect)

Features:

  - warn informatively when `bundle install` is run as root (#2936, @1337807)

## 1.6.1 (2014-04-02)

Bugfixes:

  - update C extensions when git gem versions change (#2948, @dylanahsmith)

Features:

  - add support for C extensions in sudo mode on Rubygems 2.2

## 1.6.0 (2014-03-28)

Bugfixes:

  - many Gemfiles that caused incorrect errors now resolve correctly (@Who828)
  - redirects across hosts now work on rubies without OpenSSL (#2686, @grddev)
  - gemspecs now handle filenames with newlines (#2634, @jasonmp85)
  - support escaped characters in usernames and passwords (@punkie)
  - no more exception on `update GEM` without lock file (@simi)
  - allow long config values (#2823, @kgrz)
  - cache successfully even locked to gems shipped with Ruby (#2869, @aughr)
  - respect NO_PROXY even if a proxy is configured (#2878, @stlay)
  - only retry git commands that hit the network (#2899, @timmoore)
  - fix NameError regression when OpenSSL is not available (#2898, @timmoore)
  - handle exception installing when build_info owned by root (@Who828)
  - skip HTTP redirects from rubygems.org, huge speed boost (@Who828)

Features:

  - resolver rewritten to avoid recursion (@Who828)
  - add `git_source` for custom options like :github and :gist (@strzalek)
  - HTTP auth may now be stored in `bundle config` (@smashwilson)
  - some complex Gemfiles are resolved up to 10x faster (@Who828)
  - add support for IRB alternatives such as Pry and Ripl (@joallard, @postmodern)
  - highlight installed or updated gems (#2722, #2741, @yaotti, @simi)
  - display the `post_install_message` for gems installed via :git (@phallstrom)
  - `bundle outdated --strict` now only reports allowed updates (@davidblondeau)
  - `bundle show --verbose` Add gem summary to the output (@lardcanoe)
  - `bundle gem GEM --ext` now generates a skeleton for a C extension (@superdealloc)
  - Avoid using threequals operator where possible (@as-cii)
  - Add `bundle update --group` to update specific group (#2731 @banyan)

Documentation:

  - Add missing switches for bundle-install(1) and bundle-update(1) (@as-cii)

## 1.5.3 (2014-02-06)

Bugfixes:

  - find "missing" gems that are actually present (#2780, #2818, #2854)
  - use n-1 cores when given n jobs for parallel install (@jdickey)

## 1.5.2 (2014-01-10)

Bugfixes:

  - fix integration with Rubygems 1.8.0-1.8.19
  - handle ENETDOWN exception during network requests
  - gracefully shut down after interrupt during parallel install (@Who828)
  - allow Rails to run Thor without debug mode (@rafaelfranca)
  - set git binstub permissions by umask (@v-yarotsky)
  - remove parallel install debug log

## 1.5.1 (2013-12-28)

Bugfixes:

  - correctly find gems installed with Ruby by default

## 1.5.0 (2013-12-26)

Features:

  - install missing gems if their specs are present (@hone)

Bugfixes:

  - use print for "Installing…" so messages are thread-safe (@TimMoore)

## 1.5.0.rc.2 (2013-12-18)

"Features":

  - Support threaded installation on Rubygems 2.0.7+
  - Debug installation logs in .bundle/install.log

"Bugfixes":

  - Try to catch gem installation race conditions

## 1.5.0.rc.1 (2013-11-09)

Features:

  - bundle update also accepts --jobs (#2692, @mrkn)
  - add fork URL to README for new `bundle gem` (#2665, @zzak)
  - add `bundle outdated --strict` (#2685, @davidblondeau)
  - warn if same gem/version is added twice (#2679, @jendiamond)
  - don't redownload installed specs for `bundle install` (#2680, @cainlevy)
  - override gem sources with mirrors (#2650, @danielsdeleo, @mkristian)

Bugfixes:

  - fix sharing same SSL socket when forking workers for parallel install (#2632)
  - fix msg typo in GitNotAllowedError (#2654, @joyicecloud)
  - fix Bundler.which for directories (#2697, @rhysd)
  - properly require `Capistrano::Version` (#2690, @steveklabnik)
  - search for git.exe and git
  - fix the bug that downloads every spec when API fetcher encouters an error
  - only retry network requests

## 1.4.0.rc.1 (2013-09-29)

Features:

  - add support for the x64-mingw32 platform (#2356, #2590, @larskanis)
  - add :patchlevel option to ruby DSL
  - add `bundler` bin (#2598, @kirs)
  - friendly ambiguous error messages (#2581, #2550, @jlsuttles, @jendiamond, @joyicecloud)
  - add `:jruby_18` and `:jruby_19` platform options (@mcfiredrill)
  - add X.509 client certificates for auth without passwords (@snackbandit)
  - add `exec --keep-file-descriptors` for Ruby 1.9-like behavior on 2.0 (@steved555)
  - print a better error when git is not installed (@joyicecloud)
  - exit non-zero when `outdated` is run with an unknown gem (@joyicecloud)
  - add `:ruby_21` platform option (@brandonblack)
  - add `--retry` to retry failed network and git commands (@schneems)
  - include command and versions in User-Agent (@indirect, @joyicecloud)

Bugfixes:

  - allow passwordless Basic Auth (#2606, @rykov)
  - don't suggest `gem install foo` when `foo` is a git gem that fails (@kirs)
  - revert #2569, staying compatible with git: instead of https: for :github gems
  - handle exceptions while installing gems in parallel (@gnufied)

## 1.4.0.pre.1 (2013-08-04)

Features:

  - retry network requests while installing gems (#2561, @ascherger)
  - faster installs using gemspecs from the local system cache (#2497, @mipearson)
  - add `bundle install -jN` for N parallel gem installations (#2481, @eagletmt)
  - add `ENV['DEBUG_RESOLVER_TREE']` outputs resolver tree (@dblock)
  - set $MANPATH so `bundle exec man name` works (#1624, @sunaku)
  - use `man` instead of `groff` (#2579, @ixti, @simi)
  - add Gemfile dependency info to bundle outdated output (#2487, @rahearn)
  - allow `require: true` as an alias for `require: <name>` (#2538, @ndbroadbent)
  - rescue and report Thor errors (#2478, @pjvds)
  - detect cyclic dependencies (#2564, @gnufied)
  - support multiple gems in `binstubs` (#2576, @lucasmazza)
  - use https instead of git for :github gems (#2569, @fuadsaud)
  - add quiet option to `bundle package` (#2573, @shtirlic)
  - use RUBYLIB instead of RUBYOPT for better Windows support (#2536, @equinux)

Bugfixes:

  - reduce stack size while resolving to fix JRuby overflow (#2510, @headius)
  - display GitErrors while loading specs in --verbose mode (#2461)
  - allow the same options hash to be passed to multiple gems (#2447)
  - handle missing binaries without an exception (#2019, @luismreis)

## 1.3.6 (8 January 2014)

Bugfixes:

  - make gemspec path option preserve relative paths in lock file (@bwillis)
  - use umask when creating binstubs (#1618, @v-yarotsky)
  - warn if graphviz is not installed (#2435, @Agis-)
  - show git errors while loading gemspecs
  - don't mutate gem method options hash (#2447)
  - print Thor errors (#2478, @pjvds)
  - print Rubygems system exit errors (James Cook)
  - more Pathnames into Strings for MacRuby (@kml)
  - preserve original gemspec path (@bwillis)
  - remove warning about deps with :git (#1651, @ixti)
  - split git files on null (#2634, @jasonmp85)
  - handle cross-host redirects without SSL (#2686, @grddev)
  - handle Rubygems 2 security exception (@zzak)
  - reinstall gems if they are missing with spec present
  - set binstub permissions using umask (#1618, @v-yarotsky)

## 1.3.5 (3 April 2013)

Features:

  - progress indicator while resolver is running (@chief)

Bugfixes:

  - update local overrides with orphaned revisions (@jamesferguson)
  - revert to working quoting of RUBYOPT on Windows (@ogra)
  - use basic auth even when SSL is not available (@jayniz)
  - installing git gems without dependencies in deployment now works

## 1.3.4 (15 March 2013)

Bugfixes:

  - load YAML on Rubygems versions that define module YAML
  - fix regression that broke --without on ruby 1.8.7

## 1.3.3 (13 March 2013)

Features:

  - compatible with Rubygems 2.0.2 (higher and lower already work)
  - mention skipped groups in bundle install and bundle update output (@simi)
  - `gem` creates rake tasks for minitest (@coop) and rspec

Bugfixes:

  - require rbconfig for standalone mode

## 1.3.2 (7 March 2013)

Features:

  - include rubygems.org CA chain

Bugfixes:

  - don't store --dry-run as a Bundler setting

## 1.3.1 (3 March 2013)

Bugfixes:

  - include manpages in gem, restoring many help pages
  - handle more SSL certificate verification failures
  - check for the full version of SSL, which we need (@alup)
  - gem rake task 'install' now depends on task 'build' (@sunaku)

## 1.3.0 (24 February 2013)

Features:

  - raise a useful error when the lockfile contains a merge conflict (@zofrex)
  - ensure `rake release` checks for uncommitted as well as unstaged (@benmoss)
  - allow environment variables to be negated with 'false' and '0' (@brettporter)
  - set $MANPATH inside `exec` for gems with man pages (@sunaku)
  - partial gem names for `open` and `update` now return a list (@takkanm)

Bugfixes:

  - `update` now (again) finds gems that aren't listed in the Gemfile
  - `install` now (again) updates cached gems that aren't in the Gemfile
  - install Gemfiles with HTTP sources even without OpenSSL present
  - display CerficateFailureError message in full

## 1.3.0.pre.8 (12 February 2013)

Security:

  - validate SSL certificate chain during HTTPS network requests
  - don't send HTTP Basic Auth creds when redirected to other hosts (@perplexes)
  - add `--trust-policy` to `install`, like `gem install -P` (@CosmicCat, #2293)

Features:

  - optimize resolver when too new of a gem is already activated (@rykov, #2248)
  - update Net::HTTP::Persistent for SSL cert validation and no_proxy ENV
  - explain SSL cert validation failures
  - generate gemspecs when installing git repos, removing shellouts
  - add pager selection (@csgui)
  - add `licenses` command (@bryanwoods, #1898)
  - sort output from `outdated` (@richardkmichael, #1896)
  - add a .travis.yml to `gem -t` (@ndbroadbent, #2143)
  - inform users when the resolver starts
  - disable reverse DNS to speed up API requests (@raggi)

Bugfixes:

  - raise errors while requiring dashed gems (#1807)
  - quote the Bundler path on Windows (@jgeiger, #1862, #1856)
  - load gemspecs containing unicode (@gaffneyc, #2301)
  - support any ruby version in --standalone
  - resolve some ruby -w warnings (@chastell, #2193)
  - don't scare users with an error message during API fallback
  - `install --binstubs` is back to overwriting. thanks, SemVer.

## 1.3.0.pre.7 (22 January 2013)

Bugfixes:

  - stubs for gems with dev deps no longer cause exceptions (#2272)
  - don't suggest binstubs to --binstubs users

## 1.3.0.pre.6 (22 January 2013)

Features:

  - `binstubs` lists child gem bins if a gem has no binstubs
  - `bundle gem --edit` will open the new gemspec (@ndbroadbent)
  - `bundle gem --test rspec` now makes working tests (@tricknotes)
  - `bundle env` prints info about bundler's environment (@peeja)
  - add `BUNDLE_IGNORE_CONFIG` environment variable support (@richo)

Bugfixes:

  - don't overwrite custom binstubs during `install --binstubs`
  - don't throw an exception if `binstubs` gem doesn't exist
  - `bundle config` now works in directories without a Gemfile

## 1.3.0.pre.5 (Jan 9, 2013)

Features:

  - make `--standalone` require lines ruby engine/version agnostic
  - add `--dry-run` to `bundle clean` (@wfarr, #2237)

Bugfixes:

  - don't skip writing binstubs when doing `bundle install`
  - distinguish between ruby 1.9/2.0 when using :platforms (@spastorino)

## 1.3.0.pre.4 (Jan 3, 2013)

Features:

  - `bundle binstubs <gem>` to setup individual binstubs
  - `bundle install --binstubs ""` will remove binstubs option
  - `bundle clean --dry-run` will print out gems instead of removing them

Bugfixes:

  - Avoid stack traces when Ctrl+C during bundle command (@mitchellh)
  - fix YAML parsing in in ruby-preview2

## 1.3.0.pre.3 (Dec 21, 2012)

Features:

  - pushing gems during `rake release` can be disabled (@trans)
  - installing gems with `rake install` is much faster (@utkarshkukreti)
  - added platforms :ruby_20 and :mri_20, since the ABI has changed
  - added '--edit' option to open generated gemspec in editor

Bugfixes:

  - :git gems with extensions now work with Rubygems >= 2.0 (@jeremy)
  - revert SemVer breaking change to :github
  - `outdated` exits non-zero if outdated gems found (@rohit, #2021)
  - https Gist URLs for compatibility with Gist 2.0 (@NARKOZ)
  - namespaced gems no longer generate a superfluous directory (@banyan)

## 1.3.0.pre.2 (Dec 9, 2012)

Features:

  - `config` expands local overrides like `local.rack .` (@gkop, #2205)
  - `gem` generates files correctly for names like `jquery-rails` (@banyan, #2201)
  - use gems from gists with the :gist option in the Gemfile (@jgaskins)

Bugfixes:

  - Gemfile sources other than rubygems.org work even when .gemrc contains sources
  - caching git gems now caches specs, fixing e.g. git ls-files (@bison, #2039)
  - `show GEM` now warns if the directory has been deleted (@rohit, #2070)
  - git output hidden when running in --quiet mode (@rohit)

## 1.3.0.pre (Nov 29, 2012)

Features:

  - compatibile with Ruby 2.0.0-preview2
  - compatibile with Rubygems 2.0.0.preview2 (@drbrain, @evanphx)
  - ruby 2.0 added to the `:ruby19` ABI-compatible platform
  - lazy load YAML, allowing Psych to be specified in the Gemfile
  - significant performance improvements (@cheald, #2181)
  - `inject` command for scripted Gemfile additions (Engine Yard)
  - :github option uses slashless arguements as repo owner (@rking)
  - `open` suggests gem names for typos (@jdelStrother)
  - `update` reports non-existent gems (@jdelStrother)
  - `gem` option --test can generate rspec stubs (@MafcoCinco)
  - `gem` option --test can generate minitest stubs (@kcurtin)
  - `gem` command generates MIT license (@BrentWheeldon)
  - gem rake task 'release' resuses existing tags (@shtirlic)

Bugfixes:

  - JRuby new works with HTTPS gem sources (@davidcelis)
  - `install` installs both rake rake-built gems at once (@crowbot, #2107)
  - handle Errno::ETIMEDOUT errors (@jmoses)
  - handle Errno::EAGAIN errors on JRuby
  - disable ANSI coloring when output is redirected (@tomykaira)
  - raise LoadErrors correctly during Bundler.require (@Empact)
  - do not swallow --verbose on `bundle exec` (@sol, #2102)
  - `gem` generates gemspecs that block double-requires
  - `gem` generates gemspecs that admit they depend on rake

## 1.2.5 (Feb 24, 2013)

Bugfixes:

  - install Gemfiles with HTTP sources even without OpenSSL present
  - display CerficateFailureError message in full

## 1.2.4 (Feb 12, 2013)

Features:

  - warn about Ruby 2.0 and Rubygems 2.0
  - inform users when the resolver starts
  - disable reverse DNS to speed up API requests (@raggi)

Bugfixes:

  - don't send user/pass when redirected to another host (@perplexes)
  - load gemspecs containing unicode (@gaffneyc, #2301)
  - support any ruby version in --standalone
  - resolve some ruby -w warnings (@chastell, #2193)
  - don't scare users with an error message during API fallback

## 1.2.3 (Nov 29, 2012)

Bugfixes:

  - fix exceptions while loading some gemspecs

## 1.2.2 (Nov 14, 2012)

Bugfixes:

  - support new Psych::SyntaxError for Ruby 2.0.0 (@tenderlove, @sol)
  - `bundle viz` works with git gems again (@hirochachacha)
  - recognize more cases when OpenSSL is not present

## 1.2.1 (Sep 19, 2012)

Bugfixes:

  - `bundle clean` now works with BUNDLE_WITHOUT groups again
  - have a net/http read timeout around the Gemcutter API Endpoint

## 1.2.0 (Aug 30, 2012)

Bugfixes:

  - raise original error message from LoadError's

Documentation:

  - `platform` man pages

## 1.2.0.rc.2 (Aug 8, 2012)

Bugfixes:

  - `clean` doesn't remove gems that are included in the lockfile

## 1.2.0.rc (Jul 17, 2012)

Features:

  - `check` now has a `--dry-run` option (@svenfuchs, #1811)
  - loosen ruby directive for engines
  - prune git/path directories inside vendor/cache (@josevalim, #1988)
  - update vendored thor to 0.15.2 (@sferik)
  - add .txt to LICENSE (@postmodern, #2001)
  - add `config disable_local_branch_check` (@josevalim, #1985)
  - fall back on the full index when experiencing syck errors (#1419)
  - handle syntax errors in Ruby gemspecs (#1974)

Bugfixes:

  - fix `pack`/`cache` with `--all` (@josevalim, #1989)
  - don't display warning message when `cache_all` is set
  - check for `nil` PATH (#2006)
  - Always try to keep original GEM_PATH (@drogus, #1920)

## 1.2.0.pre.1 (May 27, 2012)

Features:

  - Git gems import submodules of submodules recursively (@nwwatson, #1935)

Bugfixes:

  - Exit from `check` with a non-zero status when frozen with no lock
  - Use `latest_release` in Capistrano and Vlad integration (#1264)
  - Work around a Ruby 1.9.3p194 bug in Psych when config files are empty

Documentation:

  - Add instructions for local git repos to the `config` manpage
  - Update the `Gemfile` manpage to include ruby versions (@stevenh512)
  - When OpenSSL is missing, provide instructions for fixing (#1776 etc.)
  - Unknown exceptions now link to ISSUES for help instead of a new ticket
  - Correct inline help for `clean --force` (@dougbarth, #1911)

## 1.2.0.pre (May 4, 2012)

Features:

  - bundle package now accepts --all to package git and path dependencies
  - bundle config now accepts --local, --global and --delete options
  - It is possible to override a git repository via configuration.
    For instance, if you have a git dependency on rack, you can force
    it to use a local repo with `bundle config local.rack ~/path/to/rack`
  - Cache gemspec loads for performance (@dekellum, #1635)
  - add --full-index flag to `bundle update` (@fluxx, #1829)
  - add --quiet flag to `bundle update` (@nashby, #1654)
  - Add Bundler::GemHelper.gemspec (@knu, #1637)
  - Graceful handling of Gemfile syntax errors (@koraktor, #1661)
  - `bundle platform` command
  - add ruby to DSL, to specify version of ruby
  - error out if the ruby version doesn't match

Performance:

  - bundle exec shouldn't run Bundler.setup just setting the right rubyopts options is enough (@spastorino, #1598)

Bugfixes:

  - Avoid passing RUBYOPT changes in with_clean_env block (@eric1234, #1604)
  - Use the same ruby to run subprocesses as is running rake (@brixen)

Documentation:

  - Add :github documentation in DSL (@zofrex, #1848, #1851, #1852)
  - Add docs for the --no-cache option (@fluxx, #1796)
  - Add basic documentation for bin_path and bundle_path (@radar)
  - Add documentation for the run method in Bundler::Installer

## 1.1.5 (Jul 17, 2012)

Features:

  - Special case `ruby` directive from 1.2.0, so you can install Gemfiles that use it

## 1.1.4 (May 27, 2012)

Bugfixes:

  - Use `latest_release` in Capistrano and Vlad integration (#1264)
  - Unknown exceptions now link to ISSUES for help instead of a new ticket
  - When OpenSSL is missing, provide instructions for fixing (#1776 etc.)
  - Correct inline help for `clean --force` (@dougbarth, #1911)
  - Work around a Ruby 1.9.3p194 bug in Psych when config files are empty

## 1.1.3 (March 23, 2012)

Bugfixes:

  - escape the bundler root path (@tenderlove, #1789)

## 1.1.2 (March 20, 2012)

Bugfixes:

  - Fix --deployment for multiple PATH sections of the same source (#1782)

## 1.1.1 (March 14, 2012)

Bugfixes:

  - Rescue EAGAIN so the fetcher works on JRuby on Windows
  - Stop asking users to report gem installation errors
  - Clarify "no sources" message
  - Use $\ so `bundle gem` gemspecs work on Windows (@postmodern)
  - URI-encode gem names for dependency API (@rohit, #1672)
  - Fix `cache` edge case in rubygems 1.3.7 (#1202)

Performance:

  - Reduce invocation of git ls-files in `bundle gem` gemspecs (@knu)

## 1.1.0 (Mar 7, 2012)

Bugfixes:

  - Clean up corrupted lockfiles on bundle installs
  - Prevent duplicate GIT sources
  - Fix post_install_message when uing the endpoint API

## 1.1.rc.8 (Mar 3, 2012)

Performance:

  - don't resolve if the Gemfile.lock and Gemfile haven't changed

Bugfixes:

  - Load gemspecs from git even when a released gem has the same version (#1609)
  - Declare an accurate Ruby version requirement of 1.8.7 or newer (#1619)
  - handle gemspec development dependencies correctly (@raggi, #1639)
  - Avoid passing RUBYOPT changes in with_clean_env block. (eric1234, #1604)

## 1.1.rc.7 (Dec 29, 2011)

Bugfixes:

  - Fix bug where `clean` would break when using :path with no gemspec

## 1.1.rc.6 (Dec 22, 2011)

Bugfixes:

  - Fix performance regression from 1.0 (@spastorino, #1511, #1591, #1592)
  - Load gems correctly when GEM_HOME is blank
  - Refresh gems so Bundler works from inside a bundle
  - Handle empty .bundle/config files without an error

## 1.1.rc.5 (Dec 14, 2011)

Bugfixes:

  - Fix ASCII encoding errors with gem (rerelease with ruby 1.8)

## 1.1.rc.4 (Dec 14, 2011)

Features:

  - `bundle viz` has the option to output a DOT file instead of a PNG (@hirochachacha, #683)

Bugfixes:

  - Ensure binstubs generated when using --standalone point to the standalonde bundle (@cowboyd, #1588)
  - fix `bundle viz` (@hirochachacha, #1586)

## 1.1.rc.3 (Dec 8, 2011)

Bugfixes:

  - fix relative_path so it checks Bundler.root is actually in the beginning of the path (#1582)
  - fix bundle outdated doesn't list all gems (@joelmoss, #1521)

## 1.1.rc.2 (Dec 6, 2011)

Features:

  - Added README.md to `newgem` (@ognevsky, #1574)
  - Added LICENSE (MIT) to newgem (@ognevsky, #1571)

Bugfixes:

  - only auto-namespace requires for implied requires (#1531)
  - fix bundle clean output for git repos (#1473)
  - use Gem.bindir for bundle clean (#1544, #1532)
  - use `Gem.load_env_plugins` instead of `Gem.load_env_plugins` (#1500, #1543)
  - differentiate Ruby 2.0 (trunk) from Ruby 1.9 (@tenderlove, #1539)
  - `bundle clean` handles 7 length git hash for bundle clean (#1490, #1491)
  - fix Psych loading issues
  - Search $PATH for a binary rather than shelling out to `which` (@tenderlove, #1573)
  - do not clear RG cache unless we actually modify GEM_PATH and GEM_HOME- use `Gem.load_env_plugins` instead of `Gem.load_env_plugins` (#1500, #1543)
  - `newgem` now uses https://rubygems.org (#1562)
  - `bundle init` now uses https://rubygems.org (@jjb, #1522)
  - `bundle install/update` does not autoclean when using --path for semver

Documentation:

  - added documentation for --shebang option for `bundle install` (@lunks, #1475, #1558)

## 1.1.rc (Oct 3, 2011)

Features:

  - add `--shebang` option to bundle install (@bensie, #1467)
  - build passes on ruby 1.9.3rc1 (#1458, #1469)
  - hide basic auth credentials for custom sources (#1440, #1463)

Bugfixes:

  - fix index search result caching (#1446, #1466)
  - fix fetcher prints multiple times during install (#1445, #1462)
  - don't mention API errors from non-rubygems.org sources
  - fix autoclean so it doesn't remove bins that are used (#1459, #1460)

Documentation:

  - add :require => [...] to the gemfile(5) manpage (@nono, #1468)

## 1.1.pre.10 (Sep 27, 2011)

Features:

  - `config system_bindir foo` added, works like "-n foo" in your .gemrc file

## 1.1.pre.9 (Sep 18, 2011)

Features:

  - `clean` will now clean up all old .gem and .gemspec files, cleaning up older pres
  - `clean` will be automatically run after bundle install and update when using `--path` (#1420, #1425)
  - `clean` now takes a `--force` option (#1247, #1426)
  - `clean` will clean up cached git dirs in bundle clean (#1390)
  - remove deprecations from DSL (#1119)
  - autorequire tries directories for gems with dashed names (#1205)
  - adds a `--paths` flag to `bundle show` to list all the paths of bundled gems (@tiegz, #1360)
  - load rubygems plugins in the bundle binary (@tpope, #1364)
  - make `--standalone` respect `--path` (@cowboyd, #1361)

Bugfixes:

  - Fix `clean` to handle nested gems in a git repo (#1329)
  - Fix conflict from revert of benchmark tool (@boffbowsh, #1355)
  - Fix fatal error when unable to connect to gem source (#1269)
  - Fix `outdated` to find pre-release gems that are installed. (#1359)
  - Fix color for ui. (#1374)
  - Fix installing to user-owned system gems on OS X
  - Fix caching issue in the resolver (#1353, #1421)
  - Fix :github DSL option

## 1.1.pre.8 (Aug 13, 2011)

Bugfixes:

  - Fix `bundle check` to not print fatal error message (@cldwalker, #1347)
  - Fix require_sudo when Gem.bindir isn't writeable (#1352)
  - Fix not asking Gemcutter API for dependency chain of git gems in --deployment (#1254)
  - Fix `install --binstubs` when using --path (#1332)

## 1.1.pre.7 (Aug 8, 2011)

Bugfixes:

  - Fixed invalid byte sequence error while installing gem on Ruby 1.9 (#1341)
  - Fixed exception when sudo was needed to install gems (@spastorino)

## 1.1.pre.6 (Aug 8, 2011)

Bugfixes:

  - Fix cross repository dependencies (#1138)
  - Fix git dependency fetching from API endpoint (#1254)
  - Fixes for bundle outdated (@joelmoss, #1238)
  - Fix bundle standalone when using the endpoint (#1240)

Features:

  - Implement `to_ary` to avoid calls to method_missing (@tenderlove, #1274)
  - bundle clean removes old .gem files (@cldwalker, #1293)
  - Correcly identify missing child dependency in error message
  - Run pre-install, post-build, and post-install gem hooks for git gems (@warhammerkid, #1120)
  - create Gemfile.lock for empty Gemfile (#1218)

## 1.1.pre.5 (June 11, 2011)

Bugfixes:

  - Fix LazySpecification on Ruby 1.9 (@dpiddy, #1232)
  - Fix HTTP proxy support (@leobessa, #878)

Features:

  - Speed up `install --deployment` by using the API endpoint
  - Support Basic HTTP Auth for the API endpoint (@dpiddy, #1229)
  - Add `install --full-index` to disable the API endpoint, just in case
  - Significantly speed up install by removing unneeded gemspec fetches
  - `outdated` command shows outdated gems (@joelmoss, #1130)
  - Print gem post install messages (@csquared, #1155)
  - Reduce memory use by removing Specification.new inside method_missing (@tenderlove, #1222)
  - Allow `check --path`

## 1.1.pre.4 (May 5, 2011)

Bugfixes:

  - Fix bug that could prevent installing new gems

## 1.1.pre.3 (May 4, 2011)

Features:

  - Add `bundle outdated` to show outdated gems (@joelmoss)
  - Remove BUNDLE_* from `Bundler.with_clean_env` (@wuputah)
  - Add Bundler.clean_system, and clean_exec (@wuputah)
  - Use git config for gem author name and email (@krekoten)

Bugfixes:

  - Fix error calling Bundler.rubygems.gem_path
  - Fix error when Gem.path returns Gem::FS instead of String

## 1.1.pre.2 (April 28, 2011)

Features:

  - Add :github option to Gemfile DSL for easy git repos
  - Merge all fixes from 1.0.12 and 1.0.13

## 1.1.pre.1 (February 2, 2011)

Bugfixes:

  - Compatibility with changes made by Rubygems 1.5

## 1.1.pre (January 21, 2011)

Features:

  - Add bundle clean. Removes unused gems from --path directory
  - Initial Gemcutter Endpoint API work, BAI Fetching source index
  - Added bundle install --standalone
  - Ignore Gemfile.lock when buliding new gems
  - Make it possible to override a .gemspec dependency's source in the
    Gemfile

Removed:

  - Removed bundle lock
  - Removed bundle install <path>
  - Removed bundle install --production
  - Removed bundle install --disable-shared-gems

## 1.0.21 (September 30, 2011)

  - No changes from RC

## 1.0.21.rc (September 29, 2011)

Bugfixes:

  - Load Psych unless Syck is defined, because 1.9.2 defines YAML

## 1.0.20 (September 27, 2011)

Features:

  - Add platform :maglev (@timfel, #1444)

Bugfixes:

  - Ensure YAML is required even if Psych is found
  - Handle directory names that contain invalid regex characters

## 1.0.20.rc (September 18, 2011)

Features:

  - Rescue interrupts to `bundle` while loading bundler.rb (#1395)
  - Allow clearing without groups by passing `--without ''` (#1259)

Bugfixes:

  - Manually sort requirements in the lockfile (#1375)
  - Remove several warnings generated by ruby -w (@stephencelis)
  - Handle trailing slashes on names passed to `gem` (#1372)
  - Name modules for gems like 'test-foo_bar' correctly (#1303)
  - Don't require Psych if Syck is already loaded (#1239)

## 1.0.19.rc (September 13, 2011)

Features:

  - Compatability with Rubygems 1.8.10 installer changes
  - Report gem installation failures clearly (@rwilcox, #1380)
  - Useful error for cap and vlad on first deploy (@nexmat, @kirs)

Bugfixes:

  - `exec` now works when the command contains 'exec'
  - Only touch lock after changes on Windows (@robertwahler, #1358)
  - Keep load paths when #setup is called multiple times (@radsaq, #1379)

## 1.0.18 (August 16, 2011)

Bugfixes:

  - Fix typo in DEBUG_RESOLVER (@geemus)
  - Fixes rake 0.9.x warning (@mtylty, #1333)
  - Fix `bundle cache` again for rubygems 1.3.x

Features:

  - Run the bundle install earlier in a Capistrano deployment (@cgriego, #1300)
  - Support hidden gemspec (@trans, @cldwalker, #827)
  - Make fetch_specs faster (@zeha, #1294)
  - Allow overriding development deps loaded by #gemspec (@lgierth, #1245)

## 1.0.17 (August 8, 2011)

Bugfixes:

  - Fix rake issues with rubygems 1.3.x (#1342)
  - Fixed invalid byte sequence error while installing gem on Ruby 1.9 (#1341)

## 1.0.16 (August 8, 2011)

Features:

  - Performance fix for MRI 1.9 (@efficientcloud, #1288)
  - Shortcuts (like `bundle i`) for all commands (@amatsuda)
  - Correcly identify missing child dependency in error message

Bugfixes:

  - Allow Windows network share paths with forward slashes (@mtscout6, #1253)
  - Check for rubygems.org credentials so `rake release` doesn't hang (#980)
  - Find cached prerelease gems on rubygems 1.3.x (@dburt, #1202)
  - Fix `bundle install --without` on kiji (@tmm1, #1287)
  - Get rid of warning in ruby 1.9.3 (@smartinez87, #1231)

Documentation:

  - Documentation for `gem ..., :require => false` (@kmayer, #1292)
  - Gems provide "executables", they are rarely also binaries (@fxn, #1242)

## 1.0.15 (June 9, 2011)

Features:

  - Improved Rubygems integration, removed many deprecation notices

Bugfixes:

  - Escape URL arguments to git correctly on Windows (1.0.14 regression)

## 1.0.14 (May 27, 2011)

Features:

  - Rubinius platform :rbx (@rkbodenner)
  - Include gem rake tasks with "require 'bundler/gem_tasks" (@indirect)
  - Include user name and email from git config in new gemspec (@ognevsky)

Bugfixes:

  - Set file permissions after checking out git repos (@tissak)
  - Remove deprecated call to Gem::SourceIndex#all_gems (@mpj)
  - Require the version file in new gemspecs (@rubiii)
  - Allow relative paths from the Gemfile in gems with no gemspec (@mbirk)
  - Install gems that contain 'bundler', e.g. guard-bundler (@hone)
  - Display installed path correctly on Windows (@tadman)
  - Escape quotes in git URIs (@mheffner)
  - Improve Rake 0.9 support (@quix)
  - Handle certain directories already existing (@raggi)
  - Escape filenames containing regex characters (@indirect)

## 1.0.13 (May 4, 2011)

Features:

  - Compatibility with Rubygems master (soon to be v1.8) (@evanphx)
  - Informative error when --path points to a broken symlink
  - Support Rake 0.9 and greater (@e2)
  - Output full errors for non-TTYs e.g. pow (@josh)

Bugfixes:

  - Allow spaces in gem path names for gem tasks (@rslifka)
  - Have cap run bundle install from release_path (@martinjagusch)
  - Quote git refspec so zsh doesn't expand it (@goneflyin)

## 1.0.12 (April 8, 2011)

Features:

  - Add --no-deployment option to `install` for disabling it on dev machines
  - Better error message when git fails and cache is present (@parndt)
  - Honor :bundle_cmd in cap `rake` command (@voidlock, @cgriego)

Bugfixes:

  - Compatibility with Rubygems 1.7 and Rails 2.3 and vendored gems (@evanphx)
  - Fix changing gem order in lock (@gucki)
  - Remove color escape sequences when displaying man pages (@bgreenlee)
  - Fix creating GEM_HOME on both JRuby 1.5 and 1.6 (@nickseiger)
  - Fix gems without a gemspec and directories in bin/ (@epall)
  - Fix --no-prune option for `bundle install` (@cmeiklejohn)

## 1.0.11 (April 1, 2011)

Features:

  - Compatibility with Rubygems 1.6 and 1.7
  - Better error messages when a git command fails

Bugfixes:

  - Don't always update gemspec gems (@carllerche)
  - Remove ivar warnings (@jackdempsey)
  - Fix occasional git failures in zsh (@jonah-carbonfive)
  - Consistent lock for gems with double deps like Cap (@akahn)

## 1.0.10 (February 1, 2011)

Bugfixes:

  - Fix a regression loading YAML gemspecs from :git and :path gems
  - Requires, namespaces, etc. to work with changes in Rubygems 1.5

## 1.0.9 (January 19, 2011)

Bugfixes:

  - Fix a bug where Bundler.require could remove gems from the load
    path. In Rails apps with a default application.rb, this removed
    all gems in groups other than :default and Rails.env

## 1.0.8 (January 18, 2011)

Features:

  - Allow overriding gemspec() deps with :git deps
  - Add --local option to `bundle update`
  - Ignore Gemfile.lock in newly generated gems
  - Use `less` as help pager instead of `more`
  - Run `bundle exec rake` instead of `rake` in Capistrano tasks

Bugfixes:

  - Fix --no-cache option for `bundle install`
  - Allow Vlad deploys to work without Capistrano gem installed
  - Fix group arguments to `bundle console`
  - Allow groups to be loaded even if other groups were loaded
  - Evaluate gemspec() gemspecs in their directory not the cwd
  - Count on Rake to chdir to the right place in GemHelper
  - Change Pathnames to Strings for MacRuby
  - Check git process exit status correctly
  - Fix some warnings in 1.9.3-trunk (thanks tenderlove)

## 1.0.7 (November 17, 2010)

Bugfixes:

  - Remove Bundler version from the lockfile because it broke
    backwards compatibility with 1.0.0-1.0.5. Sorry. :(

## 1.0.6 (November 16, 2010)

Bugfixes:

  - Fix regression in `update` that caused long/wrong results
  - Allow git gems on other platforms while installing (#579)

Features:

  - Speed up `install` command using various optimizations
  - Significantly increase performance of resolver
  - Use upcoming Rubygems performance improvements (@tmm1)
  - Warn if the lockfile was generated by a newer version
  - Set generated gems' homepage to "", so Rubygems will warn

## 1.0.5 (November 13, 2010)

Bugfixes:

  - Fix regression disabling all operations that employ sudo

## 1.0.4 (November 12, 2010)

Bugfixes:

  - Expand relative :paths from Bundler.root (eg ./foogem)
  - Allow git gems in --without groups while --frozen
  - Allow gem :ref to be a symbol as well as a string
  - Fix exception when Gemfile needs a newer Bundler version
  - Explanation when the current Bundler version conflicts
  - Explicit error message if Gemfile needs newer Bundler
  - Ignore an empty string BUNDLE_GEMFILE
  - Skeleton gemspec now works with older versions of git
  - Fix shell quoting and ref fetching in GemHelper
  - Disable colored output in --deployment
  - Preserve line endings in lock file

Features:

  - Add support for 'mingw32' platform (aka RubyInstaller)
  - Large speed increase when Gemfile.lock is already present
  - Huge speed increase when many (100+) system gems are present
  - Significant expansion of ISSUES, man pages, and docs site
  - Remove Open3 from GemHelper (now it works on Windows™®©)
  - Allow setting roles in built-in cap and vlad tasks

## 1.0.3 (October 15, 2010)

Bugfixes:

  - Use bitwise or in #hash to reduce the chance of overflow
  - `bundle update` now works with :git + :tag updates
  - Record relative :path options in the Gemfile.lock
  - :groups option on gem method in Gemfile now works
  - Add #platform method and :platform option to Gemfile DSL
  - --without now accepts a quoted, space-separated list
  - Installing after --deployment with no lock is now possible
  - Binstubs can now be symlinked
  - Print warning if cache for --local install is missing gems
  - Improve output when installing to a path
  - The tests all pass! Yay!

## 1.0.2 (October 2, 2010)

Bugfix:

  - Actually include the man pages in the gem, so help works

## 1.0.1 (October 1, 2010)

Features:

  - Vlad deployment recipe, `require 'bundler/vlad'`
  - Prettier bundle graphs
  - Improved gem skeleton for `bundle gem`
  - Prompt on file clashes when generating a gem
  - Option to generate binary with gem skeleton
  - Allow subclassing of GemHelper for custom tasks
  - Chdir to gem directory during `bundle open`

Bugfixes:

  - Allow gemspec requirements with a list of versions
  - Accept lockfiles with windows line endings
  - Respect BUNDLE_WITHOUT env var
  - Allow `gem "foo", :platform => :jruby`
  - Specify loaded_from path in fake gemspec
  - Flesh out gem_helper tasks, raise errors correctly
  - Respect RBConfig::CONFIG['ruby_install_name'] in binstubs

## 1.0.0 (August 29, 2010)

Features:

  - You can now define `:bundle_cmd` in the capistrano task

Bugfixes:

  - Various bugfixes to the built-in rake helpers
  - Fix a bug where shortrefs weren't unique enough and were
    therfore colliding
  - Fix a small bug involving checking whether a local git
    clone is up to date
  - Correctly handle explicit '=' dependencies with gems
    pinned to a git source
  - Fix an issue with Windows-generated lockfiles by reading
    and writing the lockfile in binary mode
  - Fix an issue with shelling out to git in Windows by
    using double quotes around paths
  - Detect new Rubygems sources in the Gemfile and update
    the lockfile

## 1.0.0.rc.6 (August 23, 2010)

Features:

  - Much better documentation for most of the commands and Gemfile
    format

Bugfixes:

  - Don't attempt to create directories if they already exist
  - Fix the capistrano task so that it actually runs
  - Update the Gemfile template to reference rubygems.org instead
    of :gemcutter
  - bundle exec should exit with a non zero exit code when the gem
    binary does not exist or the file is not executable.
  - Expand paths in Gemfile relative to the Gemfile and not the current
    working directory.

## 1.0.0.rc.5 (August 10, 2010)

Features:

  - Make the Capistrano task more concise.

Bugfixes:

  - Fix a regression with determining whether or not to use sudo
  - Allow using the --gemfile flag with the --deployment flag

## 1.0.0.rc.4 (August 9, 2010)

Features:

  - `bundle gem NAME` command to generate a new gem with Gemfile
  - Bundle config file location can be specified by BUNDLE_APP_CONFIG
  - Add --frozen to disable updating the Gemfile.lock at runtime
    (default with --deployment)
  - Basic Capistrano task now added as 'bundler/capistrano'

Bugfixes:

  - Multiple bundler process no longer share a tmp directory
  - `bundle update GEM` always updates dependencies of GEM as well
  - Deleting the cache directory no longer causes errors
  - Moving the bundle after installation no longer causes git errors
  - Bundle path is now correctly remembered on a read-only filesystem
  - Gem binaries are installed to Gem.bindir, not #{Gem.dir}/bin
  - Fetch gems from vendor/cache, even without --local
  - Sort lockfile by platform as well as spec

## 1.0.0.rc.3 (August 3, 2010)

Features:

  - Deprecate --production flag for --deployment, since the former
    was causing confusion with the :production group
  - Add --gemfile option to `bundle check`
  - Reduce memory usage of `bundle install` by 2-4x
  - Improve message from `bundle check` under various conditions
  - Better error when a changed Gemfile conflicts with Gemfile.lock

Bugfixes:

  - Create bin/ directory if it is missing, then install binstubs
  - Error nicely on the edge case of a pinned gem with no spec
  - Do not require gems for other platforms
  - Update git sources along with the gems they contain

## 1.0.0.rc.2 (July 29, 2010)

  - `bundle install path` was causing confusion, so we now print
    a clarifying warning. The preferred way to install to a path
    (which will not print the warning) is
    `bundle install --path path/to/install`.
  - `bundle install --system` installs to the default system
    location ($BUNDLE_PATH or $GEM_HOME) even if you previously
    used `bundle install --path`
  - completely remove `--disable-shared-gems`. If you install to
    system, you will not be isolated, while if you install to
    another path, you will be isolated from gems installed to
    the system. This was mostly an internal option whose naming
    and semantics were extremely confusing.
  - Add a `--production` option to `bundle install`:
    - by default, installs to `vendor/bundle`. This can be
      overridden with the `--path` option
    - uses `--local` if `vendor/cache` is found. This will
      guarantee that Bundler does not attempt to connect to
      Rubygems and will use the gems cached in `vendor/cache`
      instead
    - Raises an exception if a Gemfile.lock is not found
    - Raises an exception if you modify your Gemfile in development
      but do not check in an updated Gemfile.lock
  - Fixes a bug where switching a source from Rubygems to git
    would always say "the git source is not checked out" when
    running `bundle install`

NOTE: We received several reports of "the git source has not
been checked out. Please run bundle install". As far as we
can tell, these problems have two possible causes:

1. `bundle install ~/.bundle` in one user, but actually running
   the application as another user. Never install gems to a
   directory scoped to a user (`~` or `$HOME`) in deployment.
2. A bug that happened when changing a gem to a git source.

To mitigate several common causes of `(1)`, please use the
new `--production` flag. This flag is simply a roll-up of
the best practices we have been encouraging people to use
for deployment.

If you want to share gems across deployments, and you use
Capistrano, symlink release_path/current/vendor/bundle to
release_path/shared/bundle. This will keep deployments
snappy while maintaining the benefits of clean, deploy-time
isolation.

## 1.0.0.rc.1 (July 26, 2010)

  - Fixed a bug with `bundle install` on multiple machines and git

## 1.0.0.beta.10 (July 25, 2010)

  - Last release before 1.0.0.rc.1
  - Added :mri as a valid platform (platforms :mri { gem "ruby-debug" })
  - Fix `bundle install` immediately after modifying the :submodule option
  - Don't write to Gemfile.lock if nothing has changed, fixing situations
    where bundle install was run with a different user than the app
    itself
  - Fix a bug where other platforms were being wiped on `bundle update`
  - Don't ask for root password on `bundle install` if not needed
  - Avoid setting `$GEM_HOME` where not needed
  - First solid pass of `bundle config`
  - Add build options
    - `bundle config build.mysql --with-mysql-config=/path/to/config`

## 1.0.0.beta.9 (July 21, 2010)

  - Fix install failure when switching from a path to git source
  - Fix `bundle exec bundle *` in a bundle with --disable-shared-gems
  - Fix `bundle *` from inside a bundle with --disable-shared-gem
  - Shim Gem.refresh. This is used by Unicorn
  - Fix install failure when a path's dependencies changed

## 1.0.0.beta.8 (July 20, 2010)

  - Fix a Beta 7 bug involving Ruby 1.9

## 1.0.0.beta.7 (July 20, 2010, yanked)

  - Running `bundle install` twice in a row with a git source always crashed

## 1.0.0.beta.6 (July 20, 2010, yanked)

  - Create executables with bundle install --binstubs
  - You can customize the location (default is app/bin) with --binstubs other/location
  - Fix a bug where the Gemfile.lock would be deleted even if the update was exited
  - Fix a bug where cached gems for other platforms were sometimes deleted
  - Clean up output when nothing was deleted from cache (it previously said
    "Removing outdated gems ...")
  - Improve performance of bundle install if the git gem was already checked out,
    and the revision being used already exists locally
  - Fix bundle show bundler in some cases
  - Fix bugs with bundle update
  - Don't ever run git commands at runtime (fixes a number of common passenger issues)
  - Fixes an obscure bug where switching the source of a gem could fail to correctly
    change the source of its dependencies
  - Support multiple version dependencies in the Gemfile
    (gem "rails", ">= 3.0.0.beta1", "<= 3.0.0")
  - Raise an exception for ambiguous uses of multiple declarations of the same gem
    (for instance, with different versions or sources).
  - Fix cases where the same dependency appeared several times in the Gemfile.lock
  - Fix a bug where require errors were being swallowed during Bundler.require

## 1.0.0.beta.1

  - No `bundle lock` command. Locking happens automatically on install or update
  - No .bundle/environment.rb. Require 'bundler/setup' instead.
  - $BUNDLE_HOME defaults to $GEM_HOME instead of ~/.bundle
  - Remove lockfiles generated by 0.9

## 0.9.26

Features:

  - error nicely on incompatible 0.10 lockfiles

## 0.9.25 (May 3, 2010)

Bugfixes:

  - explicitly coerce Pathname objects to Strings for Ruby 1.9
  - fix some newline weirdness in output from install command

## 0.9.24 (April 22, 2010)

Features:

  - fetch submodules for git sources
  - limit the bundled version of bundler to the same as the one installing
  - force relative paths in git gemspecs to avoid raising Gem::NameTooLong
  - serialize GemCache sources correctly, so locking works
  - raise Bundler::GemNotFound instead of calling exit! inside library code
  - Rubygems 1.3.5 compatibility for the adventurous, not supported by me :)

Bugfixes:

  - don't try to regenerate environment.rb if it is read-only
  - prune outdated gems with the platform "ruby"
  - prune cache without errors when there are directories or non-gem files
  - don't re-write environment.rb if running after it has been loaded
  - do not monkeypatch Specification#load_paths twice when inside a bundle

## 0.9.23 (April 20, 2010)

Bugfixes:

  - cache command no longer prunes gems created by an older rubygems version
  - cache command no longer prunes gems that are for other platforms

## 0.9.22 (April 20, 2010)

Features:

  - cache command now prunes stale .gem files from vendor/cache
  - init --gemspec command now generates development dependencies
  - handle Polyglot's changes to Kernel#require with Bundler::ENV_LOADED (#287)
  - remove .gem files generated after installing a gem from a :path (#286)
  - improve install/lock messaging (#284)

Bugfixes:

  - ignore cached gems that are for another platform (#288)
  - install Windows gems that have no architecture set, like rcov (#277)
  - exec command while locked now includes the bundler lib in $LOAD_PATH (#293)
  - fix the `rake install` task
  - add GemspecError so it can be raised without (further) error (#292)
  - create a parent directory before cloning for git 1.5 compatibility (#285)

## 0.9.21 (April 16, 2010)

Bugfixes:

  - don't raise 'omg wtf' when lockfile is outdated

## 0.9.20 (April 15, 2010)

Features:

  - load YAML format gemspecs
  - no backtraces when calling Bundler.setup if gems are missing
  - no backtraces when trying to exec a file without the executable bit

Bugfixes:

  - fix infinite recursion in Bundler.setup after loading a bundled Bundler gem
  - request install instead of lock when env.rb is out of sync with Gemfile.lock

## 0.9.19 (April 12, 2010)

Features:

  - suggest `bundle install --relock` when the Gemfile has changed (#272)
  - source support for Rubygems servers without prerelease gem indexes (#262)

Bugfixes:

  - don't set up all groups every time Bundler.setup is called while locked (#263)
  - fix #full_gem_path for git gems while locked (#268)
  - eval gemspecs at the top level, not inside the Bundler class (#269)


## 0.9.18 (April 8, 2010)

Features:

  - console command that runs irb with bundle (and optional group) already loaded

Bugfixes:

  - Bundler.setup now fully disables system gems, even when unlocked (#266, #246)
    - fixes Yard, which found plugins in Gem.source_index that it could not load
    - makes behaviour of `Bundler.require` consistent between locked and unlocked loads

## 0.9.17 (April 7, 2010)

Features:

  - Bundler.require now calls Bundler.setup automatically
  - Gem::Specification#add_bundler_dependencies added for gemspecs

Bugfixes:

  - Gem paths are not longer duplicated while loading bundler
  - exec no longer duplicates RUBYOPT if it is already set correctly

## 0.9.16 (April 3, 2010)

Features:

  - exit gracefully on INT signal
  - resolver output now indicates whether remote sources were checked
  - print error instead of backtrace when exec cannot find a binary (#241)

Bugfixes:

  - show, check, and open commands work again while locked (oops)
  - show command for git gems
    - outputs branch names other than master
    - gets the correct sha from the checkout
    - doesn't print sha twice if :ref is set
  - report errors from bundler/setup.rb without backtraces (#243)
  - fix Gem::Spec#git_version to not error on unloaded specs
  - improve deprecation, Gemfile, and command error messages (#242)

## 0.9.15 (April 1, 2010)

Features:

  - use the env_file if possible instead of doing a runtime resolve
     - huge speedup when calling Bundler.setup while locked
     - ensures bundle exec is fast while locked
     - regenerates env_file if it was generated by an older version
  - update cached/packed gems when you update gems via bundle install

Bugfixes:

  - prep for Rubygems 1.3.7 changes
  - install command now pulls git branches correctly (#211)
  - raise errors on invalid options in the Gemfile

## 0.9.14 (March 30, 2010)

Features:

  - install command output vastly improved
    - installation message now accurate, with 'using' and 'installing'
    - bundler gems no longer listed as 'system gems'
  - show command output now includes sha and branch name for git gems
  - init command now takes --gemspec option for bootstrapping gem Gemfiles
  - Bundler.with_clean_env for shelling out to ruby scripts
  - show command now aliased as 'list'
  - VISUAL env var respected for GUI editors

Bugfixes:

  - exec command now finds binaries from gems with no gemspec
  - note source of Gemfile resolver errors
  - don't blow up if git urls are changed

## 0.9.13 (March 23, 2010)

Bugfixes:

  - exec command now finds binaries from gems installed via :path
  - gem dependencies are pulled in even if their type is nil
  - paths with spaces have double-quotes to work on Windows
  - set GEM_PATH in environment.rb so generators work with Rails 2

## 0.9.12 (March 17, 2010)

  - refactoring, internal cleanup, more solid specs

Features:

  - check command takes a --without option
  - check command exits 1 if the check fails

Bugfixes:

  - perform a topological sort on resolved gems (#191)
  - gems from git work even when paths or repos have spaces (#196)
  - Specification#loaded_from returns a String, like Gem::Specification (#197)
  - specs eval from inside the gem directory, even when locked
  - virtual gemspecs are now saved in environment.rb for use when loading
  - unify the Installer's local index and the runtime index (#204)

## 0.9.11 (March 9, 2010)

  - added roadmap with future development plans

Features:

  - install command can take the path to the gemfile with --gemfile (#125)
  - unknown command line options are now rejected (#163)
  - exec command hugely sped up while locked (#177)
  - show command prints the install path if you pass it a gem name (#148)
  - open command edits an installed gem with $EDITOR (#148)
  - Gemfile allows assigning an array of groups to a gem (#114)
  - Gemfile allows :tag option on :git sources
  - improve backtraces when a gemspec is invalid
  - improve performance by installing gems from the cache if present

Bugfixes:

  - normalize parameters to Bundler.require (#153)
  - check now checks installed gems rather than cached gems (#162)
  - don't update the gem index when installing after locking (#169)
  - bundle parenthesises arguments for 1.8.6 (#179)
  - gems can now be assigned to multiple groups without problems (#135)
  - fix the warning when building extensions for a gem from git with Rubygems 1.3.6
  - fix a Dependency.to_yaml error due to accidentally including sources and groups
  - don't reinstall packed gems
  - fix gems with git sources that are private repositories

## 0.9.10 (March 1, 2010)

  - depends on Rubygems 1.3.6

Bugfixes:

  - support locking after install --without
  - don't reinstall gems from the cache if they're already in the bundle
  - fixes for Ruby 1.8.7 and 1.9

## 0.9.9 (February 25, 2010)

Bugfixes:

  - don't die if GEM_HOME is an empty string
  - fixes for Ruby 1.8.6 and 1.9

## 0.9.8 (February 23, 2010)

Features:

  - pack command which both caches and locks
  - descriptive error if a cached gem is missing
  - remember the --without option after installing
  - expand paths given in the Gemfile via the :path option
  - add block syntax to the git and group options in the Gemfile
  - support gems with extensions that don't admit they depend on rake
  - generate gems using gem build gemspec so git gems can have native extensions
  - print a useful warning if building a gem fails
  - allow manual configuration via BUNDLE_PATH

Bugfixes:

  - eval gemspecs in the gem directory so relative paths work
  - make default spec for git sources valid
  - don't reinstall gems that are already packed

## 0.9.7 (February 17, 2010)

Bugfixes:

  - don't say that a gem from an excluded group is "installing"
  - improve crippling rubygems in locked scenarios

## 0.9.6 (February 16, 2010)

Features:

  - allow String group names
  - a number of improvements in the documentation and error messages

Bugfixes:

  - set SourceIndex#spec_dirs to solve a problem involving Rails 2.3 in unlocked mode
  - ensure Rubygems is fully loaded in Ruby 1.9 before patching it
  - fix `bundle install` for a locked app without a .bundle directory
  - require gems in the order that the resolver determines
  - make the tests platform agnostic so we can confirm that they're green on JRuby
  - fixes for Ruby 1.9

## 0.9.5 (Feburary 12, 2010)

Features:

  - added support for :path => "relative/path"
  - added support for older versions of git
  - added `bundle install --disable-shared-gems`
  - Bundler.require fails silently if a library does not have a file on the load path with its name
  - Basic support for multiple rubies by namespacing the default bundle path using the version and engine

Bugfixes:

  - if the bundle is locked and .bundle/environment.rb is not present when Bundler.setup is called, generate it
  - same if it's not present with `bundle check`
  - same if it's not present with `bundle install`
