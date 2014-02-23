{join} = require 'path'
fs = require '../utils/fs'
BaseClass = require './base_class'
Pasture = require './pasture'
Client = require './client'
{Socket} = require '../webserver'

class Server extends BaseClass
  @configure 'Server'

  constructor: (@config)->
    @_ecm_count = 0
    @_drivers = {}
    @_connectedDrivers = {}
    @_clients = new Set()
    @_collections = {}



  loadDrivers: ->
    fs.readdirPromise(join(__dirname,'../drivers')).then (dirs)=>
      for d in dirs
        @_drivers[d] = require join '../drivers', d
      @_drivers


  loadPastures: ->
    @getPromise (res)=> res @_collections.pastures = new Pasture @config.configPath


  initSocket: ->
    Socket.onUserConnect (socket)=>
      socket.on 'message', -> console.log 333333, arguments
      cl = new Client socket, @
      @_clients.add cl
      cl.on 'disconnect', => cl.close()


  registerGlobals: ->
    @getResolvedPromise().then =>
      GlobalObject = require './global_object'
      global['nodedbadmin'] = new GlobalObject


  start: ->
    unless @_startPromise
      @initSocket()
      @_startPromise = @getResolvedPromise()
      .then(=> @registerGlobals())
      .then(=> @loadDrivers())
      .then(=> @loadPastures())
    @_startPromise



  execCollectionMethod: (fullCollPath, method, params...)->
    c = @_ecm_count++
    nc = "n#{c}: "
    [collProto, collPath] = fullCollPath.split '#'
    [collNS, collId] = collProto.split ':'
    console.log "#{nc}execCollectionMethod(#{fullCollPath}, #{method})", params, collProto, collPath, collNS, collId
    if collNS is 'pastures'
      console.log "#{nc} collNS is ok"
      @getPasture(collId).then (driver)->
        console.log "#{nc} @getPasture #{collId} ok"
        driver.getCollection(collPath).then (collection)->
          console.log "#{nc} driver.getCollection #{collPath} ok"
          collection[method] params...
    else if collNS is 'system' and @_collections[collId]
      @_collections[collId][method] params...
    else
      @getRejectedPromise("ERROR execCollectionMethod(#{fullCollPath}, #{method})")


  getPasture: (id)->
    @start().then =>
      @_collections.pastures.getById(id).then (pasture)=>
        unless @_connectedDrivers[pasture.id]
          driver = @_drivers[pasture.driver]
          throw @getError("no driver for pasture.driver='#{pasture.driver}'") unless driver
          @_connectedDrivers[pasture.id] = new driver.class pasture
          #@_connectedDrivers[pasture.id].on 'close', =>
          #  @_connectedDrivers[pasture.id].removeAllListeners()
          #  delete @_connectedDrivers[pasture.id]

        @_connectedDrivers[pasture.id]

###
@socket.on 'querycollection', (collPath, params, cb)->
  @getPasture('pas0').then (driver)->
    driver.getCollection(collPath).then (collection)->
      prom = collection.query(params)
      cb prom._id
      @promiseManager.add(prom)
###



module.exports = Server