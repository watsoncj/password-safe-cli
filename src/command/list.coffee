chalk        = require 'chalk'
Q            = require 'q'
keychain     = require 'keychain'
R            = require 'ramda'
safe         = require '../safe'
fuzzyFilter       = require '../fuzzy-filter'
passwordPrompt = require '../password-prompt'

printRecord = (record) ->
  console.log chalk.yellow(record.title), '[', record.username, ']'
  if record.url then console.log record.url
  if record.notes then console.log chalk.green record.notes

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
    fuzzyFilter pattern, records
  .then (matches) ->
    if matches.length is 0
      console.log 'No records found'
    R.forEach printRecord, matches
  .catch (err) ->
    console.log err, err.stack
