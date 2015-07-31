#!/usr/bin/env coffee
prompt       = require 'prompt'
defaultCmd   = require './command/default'
copyCmd      = require './command/copy'
listCmd      = require './command/list'
commands     = require './commands'

yargs = require('yargs')
.command 'copy', 'copy the first matched password to the clipboard', (yargs) ->
  yargs.option 'all',
    alias: 'a'
    describe: 'print all matches, instead of just the first'
    type: 'boolean'
  copyCmd yargs.argv

.command 'list', 'list the matched records', (yargs) ->
  listCmd yargs.argv

.command 'default', 'make file the default safe', (yargs) ->
  defaultCmd yargs.argv

.version -> require('../package').version
.strict()

argv = yargs.argv

command = argv['_']?[0]
if commands[command] is undefined
  yargs.showHelp()
  if argv['_']?[0]?
    console.error 'unknown command:', argv['_'][0]
  else
    console.error 'command missing'
