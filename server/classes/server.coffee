
BaseClass = require './baseclass'
Deferred = require './deferred'

class Server extends BaseClass
  @configure 'Server'

  constructor: (@config)->
    @_startDefer = @Deferred()
    @_startDefer.resolve()


  start: -> @_startDefer.promise()



module.exports = Server