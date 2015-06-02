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
    ], 'rasta'
    expect(matches.length).to.be.ok
    expect(matches[0].title).to.equal 'pasta'

  it 'tolerates undefined first title', ->
    matches = filter [
      title: undefined
    ,
      title: 'pizza'
    ], 'rasta'
    expect(matches[0].title).to.equal 'pizza'

  it 'tolerates undefined last title', ->
    matches = filter [
      title: 'pizza'
    ,
      title: undefined
    ], 'rasta'
    expect(matches[0].title).to.equal 'pizza'
