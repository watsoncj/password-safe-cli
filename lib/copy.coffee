{copy}       = require 'copy-paste'
notifier     = require 'node-notifier'
filter       = require './filter'

copyPassword = (record, safeName) ->
  copy record.getPassword().toString()
  notifier.notify
    title: safeName
    message: "#{record.getTitle()} password copied to the clipboard"

module.exports = (records, options)->
  filtered = filter records, options.pattern

  copied = false
  for record in filtered
    if record.getPassword().toString().trim()
      if not copied
        copyPassword record, options.safeName
        copied = true
        console.log "*".yellow,
          record.getTitle(),
          "[",
          record.getUsername().grey,
          "]"
      else if options.argv['a'] or options.argv['all']
        console.log " ",
          record.getTitle(),
          "[",
          record.getUsername().grey,
          "]"
  console.log "No entries found" unless copied

