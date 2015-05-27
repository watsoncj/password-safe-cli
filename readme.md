[![Build Status](https://travis-ci.org/watsoncj/password-safe-cli.svg?branch=master)](https://travis-ci.org/watsoncj/password-safe-cli)

Copy passwords to the clipboard from your safe.

    Usage: pws [ action ] [ safe.psafe3 ] [ pattern ] [ options ]
           pws copy safe.psafe3 bank account -a
           pws default safe.psafe3
           pws copy bank account

    Actions:
      copy                 copy the first matched password to the clipboard
      default              make safe the default

    Options:
      -a, --all            print all matches, instead of just the first

## Features

- Native notifications
- Supports pwsafe3 versions 3.01 through 3.30
- Currenly read-only


## Credits

Uses the awesome [node-passwordsafe](https://github.com/dol/node-passwordsafe) package.
