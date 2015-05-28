filter = require './filter'

describe 'filter', ->
  it 'should match exact titles', ->
    matches = filter [
        getTitle: -> 'pizza'
      ,
        getTitle: -> 'pasta'
    ], 'pasta'
    expect(matches.length).to.be.ok
    expect(matches[0].getTitle()).to.equal 'pasta'

  it 'should match fuzzy titles', ->
    matches = filter [
        getTitle: -> 'pizza'
      ,
        getTitle: -> 'pasta'
    ], 'rasta'
    expect(matches.length).to.be.ok
    expect(matches[0].getTitle()).to.equal 'pasta'

  it 'tolerates undefined first title', ->
    matches = filter [
      getTitle: ->
    ,
      getTitle: -> 'pizza'
    ], 'rasta'
    expect(matches[0].getTitle()).to.equal 'pizza'

  it 'tolerates undefined last title', ->
    matches = filter [
      getTitle: -> 'pizza'
    ,
      getTitle: ->
    ], 'rasta'
    expect(matches[0].getTitle()).to.equal 'pizza'
