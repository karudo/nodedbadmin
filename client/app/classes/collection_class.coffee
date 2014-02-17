CollectionItem = require './collection_item_class'

Collection = Ember.ArrayProxy.extend
  itemClass: CollectionItem
  limitRecords: 100
  autoload: yes

  init: ->
    @_super()
    @_load() if @get 'autoload'


  _load: ->
    console.log 'before _load', @path
    App.server.execCollectionMethod(@path, 'query').then (items)=>
      console.log 'after _load', @path
      itemClass = @get 'itemClass'
      @setObjects items.map (i)=>
        obj = itemClass.create i
        obj.set 'collection', @
        obj


Collection.reopenClass
  connect: (path)->
    @create {content: [], path}
  connectPromise: (path)->
    new Ember.RSVP.Promise (resolve)=>
      resolve @connect path



module.exports = Collection
