filter = require './filter'

describe 'filter', ->
  it 'should match exact titles', ->
    matches = filter 'pasta', [
        title: 'pizza'
      ,
        title: 'pasta'
    ]
    expect(matches.length).to.be.ok
    expect(matches[0].title).to.equal 'pasta'

  it 'should match fuzzy titles', ->
    matches = filter 'asta', [
        title: 'pizza'
      ,
        title: 'pasta'
    ]
    expect(matches.length).to.be.ok
    expect(matches[0].title).to.equal 'pasta'

  it 'should match notes', ->
    matches = filter 'ello', [
        notes: 'yellow'
      ,
        notes: 'dellow'
    ]
    expect(matches.length).to.equal 2

  it 'tolerates undefined first title', ->
    matches = filter 'rasta', [
      title: undefined
    ,
      title: 'pizza'
    ]
    expect(matches.length).to.equal 0

  it 'tolerates undefined last title', ->
    matches = filter 'rasta', [
      title: 'pizza'
    ,
      title: undefined
    ]
    expect(matches.length).to.equal 0

  it 'should weight containing matches higher', ->
    matches = filter 'wells fargo online', [
      title: 'Regonline'
    ,
      title: 'Wells Fargo Online Banking'
    ]
    expect(matches[0].title).to.equal 'Wells Fargo Online Banking'

  it 'should be curried', ->
    matches = filter('wells fargo') [
      title: 'Wells Fargo Online Banking'
    ,
      title: 'Regonline'
    ]
    expect(matches[0].title).to.equal 'Wells Fargo Online Banking'
