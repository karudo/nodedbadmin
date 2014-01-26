{BaseDbCollection} = require 'classes'

class MysqlTableCollection extends BaseDbCollection
  @configure 'MysqlTableCollection',
    connectionInit: (conn)->
      conn.query("use")

  canCache: no

  constuctor: ->
    super

  exec_query: (conn, params)->
    conn.query("show tables")



module.exports = MysqlTableCollection
