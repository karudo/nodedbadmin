BaseClass = require './base_class'
{filter, clone} = require '../utils/_'

class BaseCollection extends BaseClass
  @configure 'BaseCollection'

  @fromArray: (arr)->
    o = new @
    o.fromArray(arr)
    o

  constructor: ->
    @_items = []

  fromArray: (arr)->
    throw @getError('no array!') unless Array.isArray arr
    @_items = []
    if @itemClass
      arr = arr.map (i)=> new @itemClass i
    arr.forEach @add.bind(@)
    @_inited = yes
    @

  makeId: (idx, item)-> idx


  add: (item)->
    i = @_items.push item
    item.id = @makeId(i - 1, item) unless item.id

  query: (params = {})->
    @getResolvedPromise(clone(if params.query then filter(@_items, params.query) else @_items), 'query')

  getById: (id)->
    @query({query: {id}, top: 1}).then (arr)=>
      throw @getError('cant find by id') unless arr.length
      arr[0]


module.exports = BaseCollection