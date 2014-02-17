mysql = require 'mysql'
classes = require '../../classes'
{denodeify} = require '../../promise'


class MysqlConn extends classes.BaseConn
  @configure 'MysqlConn'

  constructor: (@poolConnection)->
    @_closed = no
    ##@query = denodeify @poolConnection.query.bind(@poolConnection)

  query: (sqlQuery)->
    console.log sqlQuery
    @getPromise (resolve)=>
      @poolConnection.query sqlQuery, (err, result, s)=>
        #console.log '3param', s
        throw @getError(err) if err
        resolve result

  escapeId: (id)-> mysql.escapeId(id)

  close: ->
    unless @_closed
      @_closed = yes
      @poolConnection.release()


module.exports = MysqlConn