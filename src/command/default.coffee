fs = require 'fs'
userHome = require '../user-home'
module.exports = (argv) ->
  argv['_'].shift() # drop command name
  fs.writeFileSync "#{userHome}/.psafe", argv['_'].join(' ')
