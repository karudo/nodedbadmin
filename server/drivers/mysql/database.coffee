{BaseDbCollection} = require 'classes'

class MysqlDatabaseCollection extends BaseDbCollection
  @configure 'MysqlTableCollection'

  canCache: no

  constuctor: ->
    super

  exec_query: (conn, params)->
    conn.query("show databases")



module.exports = MysqlDatabaseCollection
