CollectionItem = require './collection_item_class'

load = (coll, path)->
  console.log 'before load', path
  App.server.execCollectionMethod(path, 'query').then (items)->
    console.log 'after load', path
    coll.setContent items


Collection = Ember.ArrayProxy.extend
  itemClass: CollectionItem

  query: ->

  setContent: (items)->
    itemClass = @get 'itemClass'
    hi = ~@path.indexOf('/rows')
    console.log new Date()
    @setObjects items.map (i)=>
      return _.values(i) if hi
      obj = itemClass.create i
      obj.set 'collection', @
      obj
    console.log new Date()


Collection.reopenClass
  connect: (path)->
    coll = @create {content: [], path}
    load coll, path
    coll
  connectPromise: (path)->
    new Ember.RSVP.Promise (resolve)=>
      resolve @connect path



module.exports = Collection
