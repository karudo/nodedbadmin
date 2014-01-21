BaseClass = require './baseclass'
promise = require 'promise'

class Server extends BaseClass
  @configure 'Server'

  constructor: (@config)->
    @_initPromise()
    (@_startDefer = promise.defer()).resolve()

  _initPromise: ->
    #promise.configure 'instrument', on


  start: -> @_startDefer.promise



module.exports = Server