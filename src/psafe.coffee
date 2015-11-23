#!/usr/bin/env coffee
prompt        = require 'prompt'
defaultCmd    = require './command/default'
copyCmd       = require './command/copy'
saveMasterCmd = require './command/save-master'

yargs = require('yargs')
.command 'copy', 'copy the first matched password to the clipboard', (yargs) ->
  yargs.option 'all',
    alias: 'a'
    describe: 'print all matches, instead of just the first'
    type: 'boolean'
  copyCmd yargs.argv

.command 'save-master', 'save the master password to the keychain', (yargs) ->
  saveMasterCmd yargs.argv

.command 'default', 'make file the default safe', (yargs) ->
  defaultCmd yargs.argv

.version -> require('../package').version
.strict()

argv = yargs.argv

if argv['_']?[0] not in ['copy', 'default', 'save-master']
  yargs.showHelp()
  if argv['_']?[0]?
    console.error 'unknown command:', argv['_'][0]
  else
    console.error 'command missing'
