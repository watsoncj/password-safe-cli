fs = require 'fs'
module.exports = (records, options)->
  fs.writeFileSync "#{options.userhome}/.psafe", options.safePath
