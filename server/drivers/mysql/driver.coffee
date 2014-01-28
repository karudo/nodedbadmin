classes = require 'classes'
mysql = require 'mysql'
{denodeify} = require 'promise'

MysqlConn = require './conn'
MysqlDatabaseCollection = require './database'
MysqlTableCollection = require './table'
MysqlTableRowCollection = require './table_row'


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
          childs:
            rows:
              name: "Rows"
              class: MysqlTableRowCollection

  constructor: ->
    super
    @pool = mysql.createPool @pasture.params
    @getPoolConnection = denodeify(@pool.getConnection.bind(@pool))

  getConn: ->
    @getPoolConnection().then (poolConnection)->
      new MysqlConn poolConnection



module.exports = MysqlDriver