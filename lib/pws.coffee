#!/usr/bin/env coffee
argv = require('minimist')(process.argv.slice(2))
PasswordSafe = require 'password-safe'
fs           = require 'fs'
{copy}       = require 'copy-paste'
notifier     = require 'node-notifier'

fileNamePart = (path) ->
  parts = path.trim().split('/')
  parts[parts.length - 1]

matches = (haystack, needle) ->
  haystack?.toLowerCase().indexOf(needle.toLowerCase()) >= 0

safeFilePath = fs.readFileSync('.safe').toString().trim()
safeName     = fileNamePart safeFilePath

prompt = require 'prompt'
prompt.message = safeName

promptCb = (err, properties) ->
  db = fs.readFileSync safeFilePath.toString().trim()
  safe = new PasswordSafe
    password: properties.password

  safe.load db, (err, header, records) ->
    return console.log 'Error: ', err if err
    searchKey = argv['_']?.join(' ').toString()
    matching = []
    for record in records
      if matches record.getTitle().toString(), searchKey
        matching.push record

    copied = false
    for match in matching
      if match.getPassword().toString().trim()
        if not copied
          copyPassword match
          copied = true
          console.log "*".yellow,
            match.getTitle(),
            "[",
            match.getUsername().grey,
            "]"
        else if argv['a'] or argv['all']
          console.log " ",
            match.getTitle(),
            "[",
            match.getUsername().grey,
            "]"
    console.log "No entries found" unless copied

copyPassword = (record) ->
  copy record.getPassword().toString()
  notifier.notify
    title: safeName
    message: "#{record.getTitle()} password copied to the clipboard"

prompt.get
  properties:
    password:
      hidden: true
      required: true
,
  promptCb
