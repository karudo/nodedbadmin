{join} = require 'path'
fs = require '../utils/fs'
BaseClass = require './base_class'
BaseCollection = require './base_collection'
Pasture = require './pasture'
Client = require './client'

{Socket} = require '../webserver'
Logger = require '../logger'

class Server extends BaseClass
  @configure 'Server'

  constructor: (@config)->
    @logger = new Logger @config.logLevel
    @_ecm_count = 0
    @_drivers = {}
    @_connectedDrivers = {}
    @_clients = new Set()
    @_collections = {}


  loadDrivers: ->
    fs.readdirPromise(join(__dirname,'../drivers')).then (dirs)=>
      driversColl = []
      for d in dirs
        @_drivers[d] = require join '../drivers', d
        driversColl.push {id: d, name: d}
      @_collections.drivers = BaseCollection.fromArray driversColl
      @_drivers


  loadPastures: ->
    pastureFile = join @config.configPath, 'pastures.json'
    fs.readFilePromise(pastureFile).then (fileSource)=>
      pastures = JSON.parse fileSource
      pasObj = Pasture.fromArray pastures
      pasObj.on 'added', (item)=> delete @_connectedDrivers[item.id]
      pasObj.on 'changed', (item)=> delete @_connectedDrivers[item.id]
      pasObj.on 'itemsChanged', =>
        items = pasObj._items
        fileData = JSON.stringify items, null, "  "
        fs.writeFilePromise(pastureFile, fileData).then =>
          @logger.debug 'pastures saved'
      @_collections.pastures = pasObj


  initSocket: ->
    Socket.onUserConnect (socket)=>
      #socket.on 'message', -> console.log 333333, arguments
      cl = new Client socket, @
      @_clients.add cl
      cl.on 'disconnect', => cl.close()


  registerGlobals: ->
    @getResolvedPromise().then =>
      GlobalObject = require './global_object'
      global['nodedbadmin'] = new GlobalObject {@logger}


  start: ->
    @logger.debug 'Start with config', @config
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
    @logger.debug "#{nc}execCollectionMethod(#{fullCollPath}, #{method})", params, collProto, collPath, collNS, collId
    if collNS is 'pastures'
      @logger.debug "#{nc} collNS is ok"
      @getPasture(collId).then (driver)=>
        @logger.debug "#{nc} @getPasture #{collId} ok"
        driver.getCollection(collPath).then (collection)=>
          @logger.debug "#{nc} driver.getCollection #{collPath} ok"
          collection[method] params...
    else if collNS is 'system' and @_collections[collPath]
      @_collections[collPath][method] params...
    else
      @getRejectedPromise("ERROR execCollectionMethod(#{fullCollPath}, #{method})")


  getPasture: (id)->
    @start().then =>
      @_collections.pastures.getByPk(id).then (pasture)=>
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