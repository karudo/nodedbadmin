classes = require 'classes'
{denodeify} = require 'promise'


class MysqlConn extends classes.BaseConn
  @configure 'MysqlConn'

  constructor: (@poolConnection)->
    @_closed = no
    #@query = denodeify @poolConnection.query.bind(@poolConnection)

  query: (sqlQuery)->
    console.log sqlQuery
    @getPromise (resolve)=>
      @poolConnection.query sqlQuery, (err, result)=>
        throw @getError(err) if err
        resolve result


  close: ->
    unless @_closed
      @_closed = yes
      @poolConnection.release()


module.exports = MysqlConn