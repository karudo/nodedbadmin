CollectionItem = require './collection_item_class'

Collection = Ember.Object.extend
  itemClass: CollectionItem
  path: null
  query: ->
  queryModel: ->


module.exports = Collection