{join} = require 'path'
fs = require '../utils/fs'
BaseClass = require './base_class'

aerr = (err, logger)->
  logger.error err
  err

class Client extends BaseClass
  @configure 'Client'

  constructor: (@socket, @server)->
    super
    #console.log @socket
    @_id = "socket##{@socket.id}"
    @socket.on 'collection:exec:method', (fullCollPath, method, params, cb)=>
      promise = @server.execCollectionMethod fullCollPath, method, params...
      cb promise._id
      f = do(promise_id = promise._id)=>
        (err, result)=> @send 'collection:exec:method', promise_id, err, result
      promise.then ((result)=> f(no, result)), ((err)=> f(aerr(err, @server.logger)))


  send: (message, params...)->
    @socket.emit message, params...



  getId: -> @_id


  close: ->
    @removeAllListeners()


module.exports = Client