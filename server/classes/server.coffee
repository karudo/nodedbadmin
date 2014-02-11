{join} = require 'path'
fs = require '../utils/fs'
BaseClass = require './base_class'
Pasture = require './pasture'

class Server extends BaseClass
  @configure 'Server'

  constructor: (@config)->
    @_drivers = {}
    @_connected_drivers = {}


  loadDrivers: ->
    fs.readdirPromise(join(__dirname,'../drivers')).then (dirs)=>
      for d in dirs
        @_drivers[d] = require join '../drivers', d
      @_drivers

  loadPastures: ->
    @getPromise (res)=> res @_pastures = new Pasture @config.configPath

  start: ->
    unless @_startPromise
      @_startPromise = @getResolvedPromise()
      .then(=> @loadDrivers())
      .then(=> @loadPastures())
    @_startPromise



  execCollectionMethod: (collPath, method, params)->


  getPasture: (id)->
    @start().then =>
      @_pastures.getById(id).then (pasture)=>
        unless @_connected_drivers[pasture.id]
          driver = @_drivers[pasture.driver]
          throw @getError("no driver for pasture.driver='#{pasture.driver}'") unless driver
          @_connected_drivers[pasture.id] = new driver.class pasture
          #@_connected_drivers[pasture.id].on 'close', =>
          #  @_connected_drivers[pasture.id].removeAllListeners()
          #  delete @_connected_drivers[pasture.id]

        @_connected_drivers[pasture.id]




module.exports = Server