MysqlCollection = require './mysql_collection'

class MysqlTableRowCollection extends MysqlCollection
  @configure 'MysqlTableRowCollection'


  constructor: ->
    super
    @tableName = @path[-2...-1][0].query


  query: (params)->
    pageNum = parseInt (params.pageNum or 0), 10
    pageSize = parseInt (params.pageSize or 0), 10
    sql = "SELECT * FROM #{@escapeId(@tableName)} LIMIT #{(pageNum-1)*pageSize}, #{pageSize}"
    @_query(sql).then ([result])-> result


  count: ()->
    sql = "SELECT COUNT(*) as cnt FROM #{@escapeId(@tableName)}"
    @_query(sql).then ([result])-> result[0].cnt

module.exports = MysqlTableRowCollection
