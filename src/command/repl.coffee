ansiStyles = require('ansi-styles')
Q = require 'q'
Table = require 'cli-table'
readline = require('readline')
userHome = require '../user-home'
keychain     = require 'keychain'
safe = require '../safe'
filter = require '../filter'

getPasswordFromKeychain = Q.denodeify keychain.getPassword.bind keychain

module.exports = (argv) ->
  argv['_'].shift() # drop command name
  safeName = safe.name argv

  recordsPromise = null
  getRecords = ->
    if recordsPromise
      return recordsPromise

    recordsPromise = getPasswordFromKeychain
      service: 'password-safe-cli'
      account: safeName
    .catch (err) ->
      passwordPrompt safeName
    .then (password) ->
      safe.open safe.path(argv), password

  stdout = process.stdout
  stdin = process.stdin
  stdin.setRawMode true
  rl = readline.createInterface
    input: stdin
    output: stdout
    completer: (line, callback) ->
      getRecords().then (records) ->
        matches = records.map (record) ->
          record.title
        .filter (title) ->
          title.indexOf(line) == 0
        #matches = filter line, records
        #  .map (record) -> record.title
        callback null, [matches, line]

  rl.setPrompt safeName + '> '

  rl.on 'line', (line) ->
    getRecords().then (records) ->
      matches = filter line, records
    .then (matches) ->
      try
        table = new Table
          head: ['Title', 'Username', 'Password']
          chars: {'mid': '', 'left-mid': '', 'mid-mid': '', 'right-mid': ''}
        for match in matches
          table.push [
            match.title or ''
            match.username or ''
            match.password or ''
          ]
        stdout.write table.toString()
        stdout.write '\n'
        rl.prompt()
      catch e
        process.stderr.write(e)
        process.stderr.write '\n'

  rl.prompt()
