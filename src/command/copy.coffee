Q = require 'q'
{copy}       = require 'copy-paste'
notifier     = require 'node-notifier'
keychain     = require 'keychain'
safe         = require '../safe'
filter       = require '../filter'
passwordPrompt = require '../password-prompt'

copyPassword = (record, safeName) ->
  copy record.password
  notifier.notify
    title: safeName
    message: "#{record.title} password copied to the clipboard"

copyRecord = (safeName, matches, showAll) ->
  copied = false
  for record in matches
    if record.password
      if not copied
        copyPassword record, safeName
        copied = true
        console.log '*', record.title, '[', record.username, ']'
      else if showAll
        console.log ' ', record.title, '[', record.username, ']'
  if copied
    console.log 'Password copied'
  else
    console.log 'No records found'

getPasswordFromKeychain = Q.denodeify keychain.getPassword.bind keychain

module.exports = (argv) ->
  argv['_'].shift() # remove command name
  safeName = safe.name argv

  getPasswordFromKeychain
    service: 'password-safe-cli'
    account: safeName
  .catch (err) ->
    passwordPrompt safeName
  .then (password) ->
    safe.open safe.path(argv), password
  .then (records) ->
    pattern = argv['_'].join ' '
    filter pattern, records
  .then (matches) ->
    safeName = safe.name argv
    showAll = argv.a or argv.all
    copyRecord safeName, matches, showAll
  .catch (err) ->
    console.log err, err.stack
