BaseClass = require './base_class'
{filter, clone} = require '../utils/_'

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
    if @mapArr
      arr = @mapArr arr
    @_items = []
    arr.forEach @add.bind(@)
    @_inited = yes
    @

  makePk: (idx)-> "pk#{idx}"


  add: (item)->
    i = @_items.push item
    item.id = @makePk(i - 1, item) unless item.id
    @emit 'added', item
    @emit 'itemsChanged'


  updateByPk: (pk, changes)->
    @getByPk(pk).then (item)=>
      for k, v of changes
        item[k] = v
      @emit 'changed', item
      @emit 'itemsChanged'


  query: (params = {})->
    @getResolvedPromise(clone(if params.query then filter(@_items, params.query) else @_items), 'query')


  getByPk: (pk)->
    query = {}
    query[@pkFields] = pk
    @query({query}).then (arr)=>
      throw @getError('cant find by id') unless arr.length
      arr[0]




module.exports = BaseCollection