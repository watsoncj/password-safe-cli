[![Build Status](https://travis-ci.org/watsoncj/password-safe-cli.svg?branch=master)](https://travis-ci.org/watsoncj/password-safe-cli)

Copy passwords to the clipboard from your safe.

    Usage: psafe [ action ] [ safe.psafe3 ] [ pattern ] [ options ]
           psafe copy safe.psafe3 bank account -a
           psafe default safe.psafe3
           psafe copy bank account

    Actions:
      copy                 copy the first matched password to the clipboard
      default              make safe the default

    Options:
      -a, --all            print all matches, instead of just the first
      --version            show version number                                       [boolean]

## Features

- Native notifications
- Supports psafe3 versions 3.01 through 3.30
- Currenly read-only

## Installation

First make sure you have [Node.js](https://nodejs.org/) installed.

Finally, install this package:

    npm install -g password-safe-cli


## Credits

Uses the awesome [node-passwordsafe](https://github.com/dol/node-passwordsafe) and [fuzzy](https://www.npmjs.com/package/fuzzy) packages.
