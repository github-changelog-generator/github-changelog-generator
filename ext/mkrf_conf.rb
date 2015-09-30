PREFIX = "/usr/local"
MANPREFIX = "#{PREFIX}/share/man/man1"
MAN_PAGES = "man/git-*"

require "fileutils"

Dir.glob(MAN_PAGES).each do |f|
  filename = File.basename(f)
  FileUtils.cp(f, "#{MANPREFIX}/#{filename}")
end
