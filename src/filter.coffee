R = require 'ramda'
fuzzy = require 'fuzzy'

module.exports = R.curry (pattern, records) ->
  fuzzyTitleFilter = R.curry(fuzzy.filter) pattern, R.__, extract: R.prop 'title'
  fuzzyFilter = R.compose R.map(R.prop 'original'), fuzzyTitleFilter, R.filter R.prop 'title'
  fuzzyFilter records
