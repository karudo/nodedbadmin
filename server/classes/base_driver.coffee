BaseClass = require './base_class'
{isFunction, isString, clone, chain} = require '../utils/_'


class BaseDriver extends BaseClass
  @configure 'BaseDriver'

  schema: null

  constructor: (@pasture)->

  getConn: ->
    @getRejectedPromise @getError('getConn must be implemented')


  getCollection: (path)->
    if isString path
      path = path.split('/').map (v)=> ([name,query] = v.split(':')) and {name, query}

    initFuncs = []

    collectionParams = path.reduce (curSchema, pathStep, idx)=>
      curCollectionParams = curSchema.childs?[pathStep.name]
      throw @getError "333" unless curCollectionParams?.class
      curCollectionParams = chain(curCollectionParams).clone().extend(query: pathStep.query).value()
      if (idx + 1 < path.length) and isFunction(iFunc = curCollectionParams.class.getInitFunction?(pathStep, path))
        initFuncs.push do(iFunc)=>
          (conn)=> @getResolvedPromise().then(-> iFunc(conn)).then -> conn
      curCollectionParams
    , childs: @schema

    @getConn().then(@getFilterPipeFunc initFuncs.length, (conn)=>
      initFuncs.reduce(((prom, func)-> prom.then(func)), @getResolvedPromise(conn))
    ).then (conn)=> new collectionParams.class {pathQuery: collectionParams.query, conn, path, driverQuery: @pasture.driverQuery}


#x = new BaseDriver()
#x.getCollection('databases:mysql/tables:user').then -> console.log arguments

module.exports = BaseDriver