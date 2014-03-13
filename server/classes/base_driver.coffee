BaseClass = require './base_class'
{isFunction, isString, clone, chain} = require '../utils/_'


class BaseDriver extends BaseClass
  @configure 'BaseDriver'

  schema: null

  constructor: (@pasture)->
    @pathStr = "pastures:#{@pasture.id}"
    @_collections = {}

  getSchema: -> throw @getError('redeclare!')



  getCollection: (pathStr)->
    unless @_collections[pathStr]
      pathArr = pathStr.split('/').map (v)=> ([name,query] = v.split(':')) and {name, query}

      initFuncs = []

      collectionParams = pathArr.reduce (curSchema, pathStep, idx)=>
        curCollectionParams = curSchema.childs?[pathStep.name]
        throw @getError("can't find class for #{pathStep.name}") unless curCollectionParams?.class
        #curCollectionParams = chain(curCollectionParams).clone().extend(query: pathStep.query).value()
        if (idx + 1 < pathArr.length) and isFunction(iFunc = curCollectionParams.class.getInitFunction?(pathStep))
          initFuncs.push iFunc
        curCollectionParams
      , childs: @getSchema()

      coll = new collectionParams.class @, pathArr
      coll.initFuncs = initFuncs if initFuncs.length
      @_collections[pathStr] = coll

    @getResolvedPromise @_collections[pathStr]


#x = new BaseDriver()
#x.getCollection('databases:mysql/tables:user').then -> console.log arguments

module.exports = BaseDriver