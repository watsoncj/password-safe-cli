notifier     = require 'node-notifier'
safe         = require '../safe'
filter       = require '../filter'
passwordPrompt = require '../password-prompt'

listRecords = (safeName, matches) ->
  copied = false
  for record in matches
    if not copied
      copied = true
      console.log '*', record.title, '[', record.username, ']'
    else
      console.log ' ', record.title, '[', record.username, ']'
  console.log 'No entries found' unless copied

module.exports = (argv) ->
  argv['_'].shift() # remove command name
  passwordPrompt safe.name argv
  .then (password) ->
    safe.open safe.path(argv), password
  .then (records) ->
    pattern = argv['_'].join ' '
    filter records, pattern
  .then (matches) ->
    safeName = safe.name argv
    listRecords safeName, matches
  .catch (err) ->
    console.log err, err.stack
