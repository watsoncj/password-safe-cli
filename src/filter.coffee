editdistance = require 'editdistance'

module.exports = (records, pattern) ->
  compare = editdistance(pattern)

  records.sort (a, b) ->
    if a.getTitle() and b.getTitle()
      return compare.distance(a.getTitle()) - compare.distance(b.getTitle())
    else if a.getTitle()
      return -1
    else
      return 1
