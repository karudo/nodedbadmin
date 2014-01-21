{EventEmitter} = require 'events'
{clone} = require 'utils/_'
{Promise} = require 'promise'

class BaseClass extends EventEmitter
  _bc: ['BaseClass']

  @configure: (s)->
    @::_bc = clone @::_bc
    @::_bc.push s

  getPromise: (func, label)->
    new Promise func, label


module.exports = BaseClass
