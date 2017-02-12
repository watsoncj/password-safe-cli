{addIndex, curry, filter, head, identity, map} = require 'ramda'
chalk        = require 'chalk'
{copy}       = require 'copy-paste'
notifier     = require 'node-notifier'
safe         = require '../safe'
fuzzyFilter  = require '../fuzzy-filter'
getPassword  = require '../get-safe-password'
indexFilter  = addIndex filter

logRecord = (record) ->
  if record.username
    console.log ' %s [%s]', chalk.yellow(record.title), record.username
  else
    console.log ' %s', chalk.yellow(record.title)
  record

copyPassword = (record) ->
  copy record.password
  record

notify = curry (safeName, record) ->
  notifier.notify
    title: safeName
    message: "#{record.title} password copied to the clipboard"
  record

module.exports = (argv) ->
  argv['_'].shift() # remove command name
  safeName = safe.name argv
  safePath = safe.path argv
  needle = argv['_'].join ' '
  showAll = argv.a or argv.all

  filterHead = indexFilter (record, idx) -> idx == 0
  allOrFirst = if showAll then identity else filterHead

  getPassword safeName
  .then safe.open safePath
  .then fuzzyFilter needle
  .then allOrFirst
  .then map logRecord
  .then head
  .then copyPassword
  .then notify safeName
  .catch console.error
