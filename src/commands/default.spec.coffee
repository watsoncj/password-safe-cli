describe 'default command', ->
  defaultCommand = fsMock = sandbox = null
  beforeEach ->
    sandbox = sinon.sandbox.create()
    mockery.enable
      warnOnReplace: false
      warnOnUnregistered: false
      useCleanCache: true

    fsMock =
      writeFileSync: sandbox.stub()
    mockery.registerMock 'fs', fsMock

    userHomeMock = 'home'
    mockery.registerMock '../user-home', userHomeMock

    defaultCommand = require './default'

  afterEach ->
    sandbox.reset()
    mockery.resetCache()
    mockery.disable()

  it 'should write path to ~/.psafe', ->
    argv = _: ['default', 'path/to/my.psafe3']
    defaultCommand argv
    expect(fsMock.writeFileSync).to.have.been.calledWith 'home/.psafe'
