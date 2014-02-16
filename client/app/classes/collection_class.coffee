CollectionItem = require './collection_item_class'

Collection = Ember.ArrayProxy.extend
  itemClass: CollectionItem
  limitRecords: 100
  autoload: yes

  init: ->
    @_super()
    if @get 'autoload'
      @_load()

  _load: ->
    App.server.execCollectionMethod(@path, 'query').then (items)=>
      itemClass = @get 'itemClass'
      @setObjects items.map (i)-> itemClass.create i


Collection.reopenClass
  connect: (path)->
    @create {content: [], path, collection: @}
  connectPromise: (path)->
    new Ember.RSVP.Promise (resolve)=>
      resolve @connect path



module.exports = Collection
