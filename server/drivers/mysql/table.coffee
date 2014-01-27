{BaseDbCollection} = require 'classes'

class MysqlTableCollection extends BaseDbCollection
  @configure 'MysqlTableCollection'

  query: (params)->
    @conn.query("show tables").then (result)->
      result #.map (arr)-> id: chain(arr).values().first().value()



module.exports = MysqlTableCollection
