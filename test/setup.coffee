chai = require 'chai'
global.expect = chai.expect
global.mockery = require 'mockery'
global.sinon   = require 'sinon'

sinonChai = require 'sinon-chai'
chai.use sinonChai
