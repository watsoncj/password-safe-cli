fs           = require 'fs'
PasswordSafe = require 'password-safe'
Q            = require 'q'
_            = require 'lodash'
fileName     = require './file-name'
userHome     = require './user-home'

open = (path, password) ->
  Q.Promise (resolve, reject) ->
    safe = new PasswordSafe password: password

    db = fs.readFileSync path
    safe.load db, (err, header, records) ->
      return reject err if err
      resolve _.map records, (r) ->
        title: r.getTitle()
        username: r.getUsername()
        password: r.getPassword()

path = (argv) ->
  try
    fs.readFileSync("#{userHome}/.psafe").toString().trim()
  catch e
    if e?.code is 'ENOENT'
      argv['_'].shift()
    else throw e

name = (argv) ->
  fileName path argv

module.exports =
  open: open
  path: path
  name: name
