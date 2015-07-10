editdistance = require 'editdistance'

module.exports = (records, pattern) ->
  compare = editdistance(pattern)

  records.sort (a, b) ->
    if a.title and b.title
      return compare.distance(a.title) - compare.distance(b.title)
    else if a.title
      return -1
    else
      return 1
