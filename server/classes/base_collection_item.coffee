BaseClass = require './base_class'
#{isFunction} = require 'utils/_'

class BaseCollectionItem extends BaseClass
  @configure 'BaseCollectionItem'

  constructor: (@attrs)->
    @setId @attrs.id

  getId: -> @id
  setId: (@id)-> @
  get: (k)-> @attrs[k]

  getAttrs: -> @attrs



module.exports = BaseCollectionItem