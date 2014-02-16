{BaseDbCollection} = require '../../classes'
{chain} = require '../../utils/_'

class MysqlTableCollection extends BaseDbCollection
  @configure 'MysqlTableCollection'

  query: (params)->
    @conn.query("show tables").then (result)->
      result.map (arr)->
        id = chain(arr).values().first().value()
        {id, name: id}



module.exports = MysqlTableCollection
