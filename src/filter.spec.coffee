filter = require './filter'

describe 'filter', ->
  it 'should match exact titles', ->
    matches = filter [
        title: 'pizza'
      ,
        title: 'pasta'
    ], 'pasta'
    expect(matches.length).to.be.ok
    expect(matches[0].title).to.equal 'pasta'

  it 'should match fuzzy titles', ->
    matches = filter [
        title: 'pizza'
      ,
        title: 'pasta'
    ], 'asta'
    expect(matches.length).to.be.ok
    expect(matches[0].title).to.equal 'pasta'

  it 'tolerates undefined first title', ->
    matches = filter [
      title: undefined
    ,
      title: 'pizza'
    ], 'rasta'
    expect(matches.length).to.equal 0

  it 'tolerates undefined last title', ->
    matches = filter [
      title: 'pizza'
    ,
      title: undefined
    ], 'rasta'
    expect(matches.length).to.equal 0

  it 'should weight containing matches higher', ->
    matches = filter [
      title: 'Regonline'
    ,
      title: 'Wells Fargo Online Banking'
    ], 'wells fargo online'
    expect(matches[0].title).to.equal 'Wells Fargo Online Banking'

  it 'should allow for misspelled patterns', ->
    matches = filter [
      title: 'Wells Fargo Online Banking'
    ,
      title: 'Regonline'
    ], 'wellsfargo'
    expect(matches[0].title).to.equal 'Wells Fargo Online Banking'
