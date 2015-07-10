describe 'safe-name', ->
  fileName = require('./file-name')

  it 'returns the filename part', ->
    expect(fileName 'path/to/safe.psafe3').to.equal 'safe.psafe3'

  it 'handles just filename', ->
    expect(fileName 'safe.psafe3').to.equal 'safe.psafe3'
