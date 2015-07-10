fuzzy = require 'fuzzy'

module.exports = (records, pattern) ->
  records = records.filter (record) ->
    record.title?

  fuzzy.filter pattern, records,
    extract: (record) -> record.title
  ?.map (result) -> result.original
