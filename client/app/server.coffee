socket = io.connect()

connDefer = Em.RSVP.defer()
connPromise = connDefer.promise

IDS = {}

socket.on "connect", ->
  connDefer.resolve() # unless connPromise._state


connPromise.then ->
  socket.on "collection:exec:method", (id, error, result)->
    if IDS[id]
      if error
        IDS[id].reject error
      else
        IDS[id].resolve result
      delete IDS[id]


execCollectionMethod = (fullCollPath, method, params...)->
  defer = Em.RSVP.defer()
  connPromise.then ->
    socket.emit "collection:exec:method", fullCollPath, method, params, (id)->
      if id
        IDS[id] = defer
      else
        defer.reject("empty id '#{id}'")

  defer.promise

#execCollectionMethod("pasture:pas0#databases:sergeant/tables:Bands/rows", "query").then (a)-> console.log a

module.exports = {execCollectionMethod}