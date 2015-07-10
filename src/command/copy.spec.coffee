Q = require 'q'

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
    passwordPromptMock = sandbox.stub().returns Q(mockPassword)
    mockery.registerMock '../password-prompt', passwordPromptMock

    copyCommand = require './copy'
    copyCommand _: ['copy', 'mockPattern']
    .then ->
      expect(passwordPromptMock).to.have.been.calledWith 'my-safe'
      expect(copyPasteMock.copy).to.have.been.calledWith 'password one'
      expect(mockNotifier.notify).to.have.been.calledWith title: 'my-safe', message: 'title one password copied to the clipboard'
