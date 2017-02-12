{__, compose, curry, filter, map, prop} = require 'ramda'
fuzzy = require 'fuzzy'

module.exports = curry (pattern, records) ->
  fuzzyTitleFilter = curry(fuzzy.filter) pattern, __, extract: prop 'title'
  fuzzyFilter = compose map(prop 'original'), fuzzyTitleFilter, filter prop 'title'
  fuzzyFilter records
