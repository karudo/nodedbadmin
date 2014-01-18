BaseClass = require './baseclass'

promiseFuncs = ['done', 'fail', 'then']

class Promise extends BaseClass
  @configure 'Promise'
  for f in promiseFuncs
    @::[f] = do (f)->
      (args...)->
        @_deferred[f] args...
        @
  constructor: (@_deferred)->

module.exports = Promise