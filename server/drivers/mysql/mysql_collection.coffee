mysql = require 'mysql'
{BaseDbCollection} = nodedbadmin.classes
{denodeify} = nodedbadmin.promise
{logger} = nodedbadmin
#{clone} = nodedbadmin.utils._

autorelease = yes

class MysqlCollection extends BaseDbCollection
  @configure 'MysqlCollection'


  connect: ->
    unless @pool
      par =
        host: @driver.pasture.host
        user: @driver.pasture.user
        password: @driver.pasture.password
        dateStrings: yes
      @pool = mysql.createPool par
      @pool.getConnectionPromise = denodeify(@pool.getConnection, @pool)
    @pool.getConnectionPromise().then ((conn)->
      conn.queryPromise = denodeify(conn.query, conn)
      conn
    ), (err)=>
      throw @getError 'mysql connect', "#{err}"


  escapeId: (id)-> mysql.escapeId(id)


  _query: (query, inserts)->
    if inserts
      query = mysql.format query, inserts
    logger.info "Mysql exec query: #{query}"
    connProm = @connect()
    if @initFuncs and Array.isArray @initFuncs
      for f in @initFuncs
        connProm = connProm.then f
    connProm.then (conn)=>
      conn.queryPromise(query).then (r)->
        conn.release() if autorelease
        r

module.exports = MysqlCollection
