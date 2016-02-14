Q = require 'q'
{curry} = require 'ramda'

describe 'copy command', ->
  copyPasteMock = promptMock = passwordPromptMock = sandbox = mockNotifier = null

  beforeEach ->
    sandbox = sinon.sandbox.create()
    mockery.enable
      warnOnReplace: false
      warnOnUnregistered: false
      useCleanCache: true

    mockRecords = [
      title: 'title one'
      username: 'user one'
      password: 'password one'
    ,
      title: 'title two'
      username: 'user two'
      password: 'password two'
    ]

    mockSafe =
      name: -> 'my-safe'
      path: -> 'path/to/safe'
      open: -> Q(mockRecords)
    mockery.registerMock '../safe', mockSafe

    mockFilter = curry((pattern, records) -> [mockRecords[1]])
    mockery.registerMock '../fuzzy-filter', mockFilter

    copyPasteMock =
      copy: sandbox.stub()
    mockery.registerMock 'copy-paste', copyPasteMock

    mockNotifier =
      notify: sandbox.stub()
    mockery.registerMock 'node-notifier', mockNotifier

  afterEach ->
    mockery.resetCache()
    mockery.disable()
    sandbox.reset()

  it 'should unlock, copy and notify', ->
    mockPassword = '$uper$ecret'
    getPasswordMock = sandbox.stub().returns Q(mockPassword)
    mockery.registerMock '../get-safe-password', getPasswordMock
    keychainMock = getPassword: -> Q.reject()
    mockery.registerMock 'keychain', keychainMock

    copyCommand = require './copy'
    argv = _: ['copy', 'password', 'two']
    copyCommand argv
    .then ->
      expect(getPasswordMock).to.have.been.calledWith 'my-safe'
      expect(copyPasteMock.copy).to.have.been.calledWith 'password two'
      expect(mockNotifier.notify).to.have.been.called #With title: 'my-safe', message: 'title one password copied to the clipboard'
