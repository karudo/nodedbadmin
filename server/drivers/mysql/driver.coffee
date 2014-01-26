classes = require 'classes'
mysql = require 'mysql'
{denodeify} = require 'promise'

MysqlConn = require './conn'


class MysqlDriver extends classes.BaseDriver
  @configure 'MysqlDriver'

  connect: ->
    @pool = mysql.createPool @params
    @getPoolConnection = denodeify(@pool.getConnection.bind(@pool))

  getConn: ->
    @getPoolConnection().then (poolConnection)->
      new MysqlConn poolConnection



module.exports = MysqlDriver