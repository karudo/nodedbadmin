lodash = require 'lodash'

BaseClass = require './baseclass'
Promise = require './promise'

class Server extends BaseClass
  _: lodash

  constructor: (@config)->
    @_initPromise()

  _initPromise: ->
    @promise = new Promise


  start: ->
    console.log @


module.exports = Server