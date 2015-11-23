describe 'safe', ->
  sandbox = safe = fsMock = passwordSafeMock = null

  db = {}
  path = 'path/to/safe'
  password = '$uper$ecret'
  mockRecords = [
    getTitle: -> 'record one'
    getUsername: -> 'user one'
    getPassword: -> 'password one'
    getUrl:      -> 'https://record.one'
    getNotes:    -> 'The rain in Spain\nfalls mainly on the plain.'
  ,
    getTitle: -> 'record two'
    getUsername: -> 'user two'
    getPassword: -> 'password two'
    getUrl:      -> 'https://record.two'
    getNotes:    ->
  ]

  beforeEach ->
    sandbox = sinon.sandbox.create()
    mockery.enable
      warnOnReplace: false
      warnOnUnregistered: false
      useCleanCache: true
    fsMock =
      #readFileSync: sinon.stub().returns db
      readFileSync: ->
    mockery.registerMock 'fs', fsMock

    passwordSafeMock =
      load: ->
    PasswordSafeMock = -> passwordSafeMock
    mockery.registerMock 'password-safe', PasswordSafeMock
    safe = require './safe'

  afterEach ->
    sandbox.reset()
    mockery.resetCache()
    mockery.disable()

  describe 'open', ->
    beforeEach ->
      sandbox.stub(fsMock, 'readFileSync').returns db

    it 'should unlock the safe and resolve the records', (done) ->
      sandbox.stub(passwordSafeMock, 'load').callsArgWith 1, null, null, mockRecords
      safe.open(path, password)
        .then (records) ->
          expect(records[0].title).to.equal 'record one'
          expect(records[0].username).to.equal 'user one'
          expect(records[0].password).to.equal 'password one'
          expect(records[1].title).to.equal 'record two'
          expect(records[1].username).to.equal 'user two'
          expect(records[1].password).to.equal 'password two'
          expect(passwordSafeMock.load).to.have.been.calledWith db
          done()
        .catch done

    it 'should bubble up any errors while loading the safe', (done) ->
      mockError = 'mock error'
      sinon.stub(passwordSafeMock, 'load').callsArgWith 1, mockError
      safe.open(path, password)
        .then ->
          done new Error 'promise should not have resolved'
        .catch (err) ->
          expect(passwordSafeMock.load).to.have.been.calledWith db
          expect(err).to.equal mockError
          done()

  describe 'name', ->
    it 'should parse name from path', ->
      mockSafePath = 'default/path/to/mysafe.psafe3'
      sandbox.stub(fsMock, 'readFileSync').returns new Buffer(mockSafePath)
      expect(safe.name()).to.equal 'mysafe.psafe3'

  describe 'path', ->
    it 'should parse path from userHome/.psafe', ->
      mockSafePath = 'default/path/to/mysafe.psafe3'
      sandbox.stub(fsMock, 'readFileSync').returns new Buffer(mockSafePath)
      expect(safe.path()).to.equal mockSafePath

    it 'should parse path from argv', ->
      mockSafePath = 'cli/path/to/mysafe.psafe3'
      mockError = new Error('testing no ~/.psafe file')
      mockError.code = 'ENOENT'
      sandbox.stub(fsMock, 'readFileSync').throws mockError
      expect(safe.path(_: [mockSafePath])).to.equal mockSafePath


