CollectionItem = require './collection_item_class'

class CachedCollection
  constructor: (@path, @method, @params, @itemClass)->
    @collection = Ember.ArrayProxy.create(content: [])
    @reload()

  reload: ->
    App.server.execCollectionMethod(@path, @method, @params...).then (items)=>
      @collection.setObjects items.map (i)=> @itemClass.create i

collections = {}
cachedCollections = {}

Collection = Ember.Object.extend
  itemClass: CollectionItem
  path: null

  query: (params...)->
    App.server.execCollectionMethod(@path, 'query', params...).then (items)=>
      itemClass = @get('itemClass')
      items.map (i)-> itemClass.create i

  queryModel: (params...)->
    coll = Ember.ArrayProxy.create(content: [])
    @query(params...).then (items)->
      coll.setObjects items
    coll

  cachedQuery: (params...)->
    unless cachedCollections.hasOwnProperty @path
      cachedCollections[@path] = new CachedCollection @path, 'query', params, @get('itemClass')
    cachedCollections[@path].collection
  reloadCachedQuery: ->
    cachedCollections[@path]?.reload()



objForExtend = {}
for m in ['count', 'getStructure', 'getByPk', 'updateByPk', 'add']
  objForExtend[m] = do(m)->
    (params...)-> App.server.execCollectionMethod(@path, m, params...)
Collection.reopen objForExtend

Collection.reopenClass
  getByPath: (path)->
    unless collections[path]
      collections[path] = Collection.create {path}
    collections[path]
  reloadCachedQuery: (path)->
    @getByPath(path).reloadCachedQuery()


module.exports = Collection