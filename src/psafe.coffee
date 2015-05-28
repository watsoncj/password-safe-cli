#!/usr/bin/env coffee
minimist     = require('minimist')
copy         = require './copy'
fs           = require 'fs'
PasswordSafe = require 'password-safe'
prompt       = require 'prompt'

argv = minimist process.argv.slice(2)

usage = ->
  console.log """\
Usage: psafe [ action ] [ safe.psafe3 ] [ pattern ] [ options ]
       psafe copy safe.psafe3 bank account -a
       psafe default safe.psafe3
       psafe copy bank account

Actions:
  copy                 copy the first matched password to the clipboard
  default              make safe the default

Options:
  -a, --all            print all matches, instead of just the first
"""

userhome = process.env[if process.platform is 'win32' then 'USERPROFILE' else 'HOME']

actions = ['copy', 'default']
actionOpt = argv['_'].shift()
if actionOpt not in actions
  console.error "Unknown action: #{action.yellow}" if action
  return usage()
action = require "./#{actionOpt}"

patternOpt = argv['_']?.join(' ').toString()
if not patternOpt
  console.error "Pattern required"
  return usage()

try
  safeFilePath = fs.readFileSync("#{userhome}/.psafe").toString().trim()
catch
  safeFilePath = argv['_'].shift()

fileNamePart = (path) ->
  parts = path.trim().split('/')
  parts[parts.length - 1]

safeName     = fileNamePart safeFilePath

openSafe = (err, properties) ->
  db = fs.readFileSync safeFilePath.toString().trim()
  safe = new PasswordSafe
    password: properties.password

  safe.load db, (err, header, records) ->
    return console.log 'Error: ', err if err
    options =
      pattern: patternOpt
      safeName: safeName
      safePath: safeFilePath
      argv: argv
      userhome: userhome

    action records, options

passwordPrompt = (safeName, done) ->
  schema =
    properties:
      password:
        hidden: true
        required: true

  prompt.message = safeName
  prompt.get schema, done

passwordPrompt safeName, openSafe
