Q              = require 'q'
keychain       = require 'keychain'
safe           = require '../safe'
passwordPrompt = require '../password-prompt'

setPassword = Q.denodeify keychain.setPassword.bind keychain

module.exports = (argv) ->
  argv['_'].shift() # remove command name
  safeName = safe.name argv

  passwordPrompt safeName
  .then (password) ->
    # verify safe password
    safe.open safe.path(argv), password
    .then ->
      setPassword
        service: 'password-safe-cli'
        account: safeName
        password: password
  .then ->
    console.log 'Password saved.'
  .catch (err) ->
    console.log err
