classes = require 'classes'
mysql = require 'mysql'
{denodeify} = require 'promise'

MysqlConn = require './conn'
MysqlDatabaseCollection = require './database'
MysqlTableCollection = require './table'


class MysqlDriver extends classes.BaseDriver
  @configure 'MysqlDriver'
  schema:
    databases:
      name: 'Databases'
      class: MysqlDatabaseCollection
      childs:
        tables:
          name: 'Tables'
          class: MysqlTableCollection

  constructor: ->
    super
    @pool = mysql.createPool @pasture.params
    @getPoolConnection = denodeify(@pool.getConnection.bind(@pool))

  getConn: ->
    @getPoolConnection().then (poolConnection)->
      new MysqlConn poolConnection



module.exports = MysqlDriver