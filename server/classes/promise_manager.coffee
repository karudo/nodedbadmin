BaseClass = require './base_class'
{isFunction, isString, clone, chain} = require '../utils/_'


class PromiseManager extends BaseClass
  @configure 'PromiseManager'

  constructor: ->
    super
    @_promises = {}



module.exports = PromiseManager






