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
    @getStructure().then (struct)=>
      sql = "SELECT * FROM ?? WHERE ??=?"
      @_query(sql, [@tableName, struct.pkFields, pk]).then ([result])-> result[0]


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


  updateByPk: (pk, fields)->
    @getStructure().then (struct)=>
      vars = [@tableName]

      for k, v of fields
        vars.push k
        vars.push v

      vars.push struct.pkFields
      vars.push pk

      sql = "UPDATE ?? SET #{(Object.keys(fields).map(->'??=?')).join(',')} WHERE ??=?"

      @_query sql, vars


  add: (fields)->
    @getStructure().then (struct)=>
      vars1 = []
      vars2 = []
      for k, v of fields
        vars1.push k
        vars2.push v
      sql = "INSERT INTO ?? (#{vars1.map(->'??')}) VALUES (#{vars1.map(->'?')})"
      @_query(sql, [@tableName].concat(vars1, vars2)).then ([{insertId}])->
        insertId


  deleteByPk: (pk)->
    @getStructure().then (struct)=>
      sql = 'DELETE FROM ?? WHERE ??=?'
      @_query(sql, [@tableName, struct.pkFields, pk])


module.exports = MysqlTableRowCollection
