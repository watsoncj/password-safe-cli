{copy}       = require 'copy-paste'
notifier     = require 'node-notifier'
safe         = require '../safe'
filter       = require '../filter'
passwordPrompt = require '../password-prompt'

copyPassword = (record, safeName) ->
  copy record.password
  notifier.notify
    title: safeName
    message: "#{record.title} password copied to the clipboard"

copyRecord = (safe, argv) -> (sorted) ->
  copied = false
  for record in sorted
    if record.password
      if not copied
        copyPassword record, safe.name argv
        copied = true
        console.log "*",
          record.title,
          "[",
          record.username,
          "]"
      else if argv['a'] or argv['all']
        pattern = argv['_'].join ' '
        if record.title?.indexOf(pattern) > -1
          console.log " ",
            record.title,
            "[",
            record.username,
            "]"
  console.log "No entries found" unless copied

module.exports = (argv) ->

  argv['_'].shift() # remove command name
  passwordPrompt safe.name argv
  .then (password) ->
    safe.open safe.path(argv), password
  .then (records) ->
    pattern = argv['_'].join ' '
    filter records, pattern
  .then copyRecord safe, argv
  .catch (err) ->
    console.log err, err.stack
