BaseClass = require './base_class'
{filter, clone, isString} = require '../utils/_'

class BaseCollection extends BaseClass
  @configure 'BaseCollection'

  @fromArray: (arr)->
    o = new @
    o.fromArray(arr)
    o

  pkFields: 'id'

  constructor: ->
    @_items = []

  fromArray: (arr)->
    throw @getError('no array!') unless Array.isArray arr
    @_items = []
    arr.forEach @add.bind(@)
    @_inited = yes
    @

  makePk: (idx)-> "pk#{idx}"


  getStructure: ->
    return @getRejectedPromise('no structure') unless @structure
    struct = for k, v of @structure
      fInfo = if isString v then {type: v} else clone v
      fInfo.name = k
      fInfo

    @getResolvedPromise
      pkFields: @pkFields
      fields: struct


  add: (item)->
    i = @_items.push item
    item[@pkFields] = @makePk(i - 1, item) unless item[@pkFields]
    @emit 'added', item
    @emit 'itemsChanged'
    @getResolvedPromise(item.id)


  updateByPk: (pk, changes)->
    @getByPk(pk).then (item)=>
      for k, v of changes
        item[k] = v
      @emit 'changed', item
      @emit 'itemsChanged'
      @getResolvedPromise()


  deleteByPk: (pk)->
    @getByPk(pk).then (item)=>
      idx = @_items.indexOf item
      if idx >= 0
        @_items.splice idx, 1
      @emit 'deleted', item
      @emit 'itemsChanged'
      idx >= 0


  query: (params = {})->
    arr = if params.query then filter(@_items, params.query) else @_items
    @getResolvedPromise (if @mapArr then @mapArr arr else arr), 'query'


  getByPk: (pk)->
    query = {}
    query[@pkFields] = pk
    @query({query}).then (arr)=>
      throw @getError('BaseCollection.getByPk', 'cant find by pk') unless arr.length
      arr[0]

  count: ->
    @getResolvedPromise(@_items.length)




module.exports = BaseCollection