{BaseDbCollection} = require '../../classes'
{chain} = require '../../utils/_'

class MysqlDatabaseCollection extends BaseDbCollection
  @configure 'MysqlDatabaseCollection'
  @getInitFunction: (pathStep, path)->
    (conn)->
      conn.query("use " + pathStep.query)
  #  (conn)-> console.log 'conn', conn, pathStep, path, path.indexOf pathStep


  constuctor: ->
    super

  query: (params)->
    console.log @
    @conn.query("show databases").then (result)=>
      result.map (arr)=>
        id = chain(arr).values().first().value()
        {id, name: id, defQuery: "#{@driverQuery}#databases:#{id}/tables"}



module.exports = MysqlDatabaseCollection
