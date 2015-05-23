## password-safe-cli

A command-line interface for password-safe files.

Copy password to the clipboard:

    $ pws my bank
    * My Bank Online [ username ]

## Features

- Native notifications
- Supports pwsafe3 versions 3.01 through 3.30
- Currenly read-only

## Usage

    pws [options] &lt;search text&gt;
    options:
      -a    list all matches, not just the first match

## Credits

Uses the awesome [node-passwordsafe](https://github.com/dol/node-passwordsafe) package.
