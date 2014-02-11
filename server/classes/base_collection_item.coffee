BaseClass = require './base_class'

class BaseCollectionItem extends BaseClass
  @configure 'BaseCollectionItem'

  constructor: (@attrs)->
    @setId @attrs.id

  getId: -> @id
  setId: (@id)-> @
  get: (k)-> @attrs[k]

  getAttrs: -> @attrs



module.exports = BaseCollectionItem