{BaseDbCollection} = require 'classes'

class MysqlTableRowCollection extends BaseDbCollection
  @configure 'MysqlTableRowCollection'

  constructor: ->
    super
    @tableName =  @path[-2...-1][0].query

  query: (params)->
    @conn.query("select * from #{@conn.escapeId(@tableName)}").then (result)->
      result #.map (arr)-> id: chain(arr).values().first().value()



module.exports = MysqlTableRowCollection
