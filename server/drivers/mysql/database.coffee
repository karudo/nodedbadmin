MysqlCollection = require './mysql_collection'
{chain} = nodedbadmin.utils._


class MysqlDatabaseCollection extends MysqlCollection
  @configure 'MysqlDatabaseCollection'

  @getInitFunction: (pathStep)->
    (conn)=>
      conn.queryPromise("use #{pathStep.query}").then -> conn


  query: (params)->
    @_query("show databases").then ([result])=>
      result.map (arr)=>
        id = chain(arr).values().first().value()
        {id, name: id, defQuery: @getPathStr(id, 'tables')}



module.exports = MysqlDatabaseCollection
