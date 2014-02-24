MysqlCollection = require './mysql_collection'
{chain} = nodedbadmin.utils._

class MysqlTableCollection extends MysqlCollection
  @configure 'MysqlTableCollection'

  query: (params)->
    @_query("show tables").then ([result])=>
      result.map (arr)=>
        id = chain(arr).values().first().value()
        {id, name: id, defPath: @getPathStr(id, 'rows')}



module.exports = MysqlTableCollection
