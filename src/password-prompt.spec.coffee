describe 'password prompt', ->

  sandbox = passwordPrompt = promptMock = null
  mockPassword = '$uper$ecret'
  mockSafeName = 'mock safe name'
  mockError = new Error('mock error')

  beforeEach ->
    sandbox = sinon.sandbox.create()
    mockery.enable
      warnOnReplace: false
      warnOnUnregistered: false
      useCleanCache: true
    promptMock =
      get: ->
    mockery.registerMock 'prompt', promptMock

    passwordPrompt = require './password-prompt'

  afterEach ->
    sandbox.reset()
    mockery.resetCache()
    mockery.disable()

  it 'should promise the password', ->
    sinon.stub(promptMock, 'get').callsArgWith 1, null, password: mockPassword
    passwordPrompt(mockSafeName)
      .then (password) ->
        expect(promptMock.message).to.equal mockSafeName
        expect(password).to.equal mockPassword

  it 'should reject with any errors', ->
    sinon.stub(promptMock, 'get').callsArgWith 1, mockError
    passwordPrompt(mockSafeName)
      .catch (err) ->
        expect(promptMock.message).to.equal mockSafeName
        expect(err).to.equal mockError

