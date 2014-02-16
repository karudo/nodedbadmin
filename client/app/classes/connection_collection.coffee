CollectionClass = require './collection_class'
CollectionItemClass = require './collection_item_class'

ConnectionItem = CollectionItemClass.extend()


Connection = CollectionClass.extend
  itemClass: ConnectionItem
  isConnected: no

Connection.reopenClass
  connect: ->
    @_super 'system:pastures'

module.exports = Connection