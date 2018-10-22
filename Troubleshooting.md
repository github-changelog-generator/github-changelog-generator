# Troubleshooting#

## When I try to run github_changelog_generator I get a message that says:
    'github_changelog_generator' is not recognized as an internal or external command, operable program or batch file.

You may not have added github_changelog_generator to your environment path.

1. In Windows 10 go to your settings
2. In the search, type the word "path" and press enter
3. Click on "Edit environment variables for you account"
4. Double click on Path
5. Click on New and then Edit
6. Browse C:\Ruby(version)\bin and select that folder
7. Click ok and close those windows for your settings
8. If you have a prompt open as an administrator, close it and open it again (this will clear the paths in it's memory)
9. Now cd to the correct directory and type github_changelog_generator. If you get a message stating "Usage: github_changelog_generator [options]" then the path is correct.
