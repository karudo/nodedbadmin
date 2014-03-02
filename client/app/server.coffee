server = {}
Ember.RSVP.EventTarget.mixin(server)

socket = io.connect()

connDefer = Em.RSVP.defer()
connPromise = connDefer.promise

IDS = {}

socket.on "connect", ->
  connDefer.resolve() # unless connPromise._state


connPromise.then ->
  socket.on "collection:exec:method", (id, error, result)->
    #console.log "qqqq #{error}, #{result}"
    if IDS[id]
      if error
        App.log 'ERROR:exec:method', error
        server.trigger 'error', error
        IDS[id].reject error
      else
        IDS[id].resolve result
      delete IDS[id]


server.execCollectionMethod = (fullCollPath, method, params...)->
  defer = Em.RSVP.defer()
  connPromise.then ->
    if ENV.DEBUG
      console?.log 'collection:exec:method', fullCollPath, method, params
    socket.emit "collection:exec:method", fullCollPath, method, params, (id)->
      if id
        IDS[id] = defer
      else
        defer.reject("empty promise id '#{id}'")

  defer.promise

#execCollectionMethod("pasture:pas0#databases:sergeant/tables:Bands/rows", "query").then (a)-> console.log a

module.exports = server