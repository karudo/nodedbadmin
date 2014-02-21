mysql = require 'mysql'
{BaseDbCollection} = nodedbadmin.classes
{denodeify} = nodedbadmin.promise

class MysqlCollection extends BaseDbCollection
  @configure 'MysqlCollection'


  connect: ->
    unless @pool
      @pool = mysql.createPool(@driver.pasture.params)
      @pool.getConnectionPromise = denodeify(@pool.getConnection, @pool)
    @pool.getConnectionPromise().then (conn)->
      conn.queryPromise = denodeify(conn.query, conn)
      conn
    ###
    @getPromise (resolve, reject)=>
      @pool.getConnection (err, conn)->
        if err
          reject err
        else
          conn.queryPromise = denodeify(conn.query, conn)
          resolve conn
    ###

  escapeId: (id)-> mysql.escapeId(id)
  _query: (query, autorelease = yes)->
    console.log "Mysql exec query: #{query}"
    connProm = @connect()
    if @initFuncs and Array.isArray @initFuncs
      for f in @initFuncs
        connProm = connProm.then f
    connProm.then (conn)=>
      conn.queryPromise(query).then (r)->
        conn.release() if autorelease
        r

module.exports = MysqlCollection
