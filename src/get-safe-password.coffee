Q              = require 'q'
keychain       = require 'keychain'
passwordPrompt = require './password-prompt'

getPasswordFromKeychain = Q.denodeify keychain.getPassword.bind keychain

getPassword = (safeName) ->
  getPasswordFromKeychain
    service: 'password-safe-cli'
    account: safeName
  .catch (err) ->
    passwordPrompt safeName

module.exports = getPassword
