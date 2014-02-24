CollectionItem = require './collection_item_class'

itemsMap = (items, coll, itemClass)->
  items.map (i)->
    obj = itemClass.create i
    #obj.set 'collection', coll
    obj

#getStructure
obj =
  itemClass: CollectionItem
  path: null

  query: (params...)->
    App.server.execCollectionMethod(@path, 'query', params...).then (items)=>
      coll = Ember.ArrayProxy.create content: []
      coll.setObjects itemsMap(items, coll, @get('itemClass'))
      coll

  queryModel: (params...)->
    coll = Ember.ArrayProxy.create(content: [])
    App.server.execCollectionMethod(@path, 'query', params...).then (items)=>
      coll.setObjects itemsMap(items, coll, @get('itemClass'))
    coll

for m in ['count', 'getStructure', 'getByPk']
  obj[m] = do(m)-> (params...)->
    App.server.execCollectionMethod(@path, m, params...)

Collection = Ember.Object.extend obj

Collection.reopenClass
  getByPath: (path)->
    Collection.create {path}


module.exports = Collection