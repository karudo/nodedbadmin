MysqlCollection = require './mysql_collection'

class MysqlTableRowCollection extends MysqlCollection
  @configure 'MysqlTableRowCollection'


  constructor: ->
    super
    @tableName = @path[-2...-1][0].query


  query: (params)->
    pageNum = parseInt (params.pageNum or 0), 10
    pageSize = parseInt (params.pageSize or 0), 10
    sql = "SELECT * FROM ?? LIMIT ?, ?"
    @_query(sql, [@tableName, (pageNum-1)*pageSize, pageSize]).then ([result])-> result


  count: ()->
    sql = "SELECT COUNT(*) as cnt FROM ??"
    @_query(sql, [@tableName]).then ([result])-> result[0].cnt


  getByPk: (pk)->
    sql = "SELECT * FROM ?? WHERE id=?"
    @_query(sql, [@tableName, pk]).then ([result])-> result[0]

  getStructure: ->
    @_query('DESCRIBE ??', [@tableName]).then ([result])->
      pkFields = null
      fields = result.map (fInfo)->
        ret = {name: fInfo.Field, type: 'string'}
        if fInfo.Key is 'PRI'
          pkFields = ret.name
          ret.canEdit = no
        ret
      {fields, pkFields}


module.exports = MysqlTableRowCollection
