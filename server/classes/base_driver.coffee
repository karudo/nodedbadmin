mysql = require 'mysql'
BaseDbCollection = require './base_db_collection'

class BaseDriver extends BaseDbCollection
  @configure 'BaseDriver'

  constructor: (pasture, schema)->
    super childs: schema
    @id = pasture.id
    @params = pasture.params
    @connect()

  connect: ->
    throw @getError('must be implemented')

  getDriver: -> @


  getConn: ->
    throw @getError('must be implemented')





module.exports = BaseDriver