R = require 'ramda'
Sifter = require 'sifter'

module.exports = R.curry (pattern, records) ->
  sifter = new Sifter records
  results = sifter.search pattern, fields: ['title', 'notes']
  results.items.map (item) ->
    records[item.id]
