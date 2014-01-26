BaseCollection = require './base_collection'
promise = require 'promise'
{Promise} = promise
BaseDbCollectionItem = require './base_db_collection_item'

class BaseDbCollection extends BaseCollection
  ###
  _conn_init_funcs: []
  @configure: (className, params = {})->
    super className
    if params.connectionInit
      @::_conn_init_funcs = clone @::_conn_init_funcs
      @::_conn_init_funcs.push (obj)->
        (conn)->
          Promise.resolve().then(-> params.connectionInit(conn)).then -> conn
  ###

  @configure 'BaseDbCollection'

  canCache: no

  constructor: (@schema, @driver, @parent)->



  getDriver: -> @driver


  exec: (method, params)->
    exConn = null
    methodName = "exec_#{method}"
    @getSettledPromise(!!@[methodName]).then(=> @getConn())
    .then((conn)=>
        exConn = conn
        @[methodName] conn, params
      ).finally -> exConn?.close?()


  getConn: ->
    @driver.getConn()
    ###
    .then (conn)=>
      if @_conn_init_funcs?.length
        @_conn_init_funcs.reduce ((prom, func)=> prom.then(func(@))), @getResolvedPromise(conn)
      else
        conn
    ###

  query: (params)->
    if @canCache and @_inited
      super params
    else
      @exec('query', params).then @getFilterPipeFunc @canCache, (arr)=>
        @fromArray(arr)
        super params


  exec_query: (conn, params)->
    throw @getError 'must be implemented'


  getChild: (childCode)->
    @getPromise (resolve)=>
      childInfo = @schema?.childs?[childCode]
      throw @getError('no child '+childCode) unless childInfo
      resolve new childInfo.class childInfo, @getDriver(), @




module.exports = BaseDbCollection