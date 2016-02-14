fuzzyFilter = require './fuzzy-filter'

describe 'fuzzyFilter', ->
  it 'should match exact titles', ->
    matches = fuzzyFilter 'pasta', [
        title: 'pizza'
      ,
        title: 'pasta'
    ]
    expect(matches.length).to.be.ok
    expect(matches[0].title).to.equal 'pasta'

  it 'should match fuzzy titles', ->
    matches = fuzzyFilter 'asta', [
        title: 'pizza'
      ,
        title: 'pasta'
    ]
    expect(matches.length).to.be.ok
    expect(matches[0].title).to.equal 'pasta'

  it 'tolerates undefined first title', ->
    matches = fuzzyFilter 'rasta', [
      title: undefined
    ,
      title: 'pizza'
    ]
    expect(matches.length).to.equal 0

  it 'tolerates undefined last title', ->
    matches = fuzzyFilter 'rasta', [
      title: 'pizza'
    ,
      title: undefined
    ]
    expect(matches.length).to.equal 0

  it 'should weight containing matches higher', ->
    matches = fuzzyFilter 'wells fargo online', [
      title: 'Regonline'
    ,
      title: 'Wells Fargo Online Banking'
    ]
    expect(matches[0].title).to.equal 'Wells Fargo Online Banking'

  it 'should allow for misspelled patterns', ->
    matches = fuzzyFilter 'wellsfargo', [
      title: 'Wells Fargo Online Banking'
    ,
      title: 'Regonline'
    ]
    expect(matches[0].title).to.equal 'Wells Fargo Online Banking'

  it 'should be curried', ->
    matches = fuzzyFilter('wellsfargo') [
      title: 'Wells Fargo Online Banking'
    ,
      title: 'Regonline'
    ]
    expect(matches[0].title).to.equal 'Wells Fargo Online Banking'
