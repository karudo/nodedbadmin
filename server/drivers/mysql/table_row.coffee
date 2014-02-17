MysqlCollection = require './mysql_collection'

class MysqlTableRowCollection extends MysqlCollection
  @configure 'MysqlTableRowCollection'

  constructor: ->
    super
    @tableName = @path[-2...-1][0].query

  query: (params)->
    sql = "select * from #{@escapeId(@tableName)}"
    @_query(sql).then ([result])=> result

module.exports = MysqlTableRowCollection
