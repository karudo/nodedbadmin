BaseCollectionItem = require './base_collection_item'


class BaseDbCollectionItem extends BaseCollectionItem
  @configure 'BaseDbCollectionItem'


  getChildCollection: ->


module.exports = BaseDbCollectionItem