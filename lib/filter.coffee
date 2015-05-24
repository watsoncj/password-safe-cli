isMatch = (haystack, needle) ->
  haystack?.toLowerCase().indexOf(needle.toLowerCase()) >= 0

module.exports = (records, pattern) ->
  filtered = []
  for record in records
    if isMatch record.getTitle().toString(), pattern
      filtered.push record
  filtered
