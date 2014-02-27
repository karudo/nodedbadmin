BaseClass = require './base_class'


class BaseDbCollection extends BaseClass
  @configure 'BaseDbCollection'

  constructor: (@driver, @path)->
    super

  getPathStr: (curId, defColl)->
    "#{@driver.pathStr}#" + @path.map(({name, query})-> "#{name}:#{if query then query else curId}").join('/') + "/#{defColl}"

  query: ->
    throw new Error "query must be redeclared"

  getByPk: ->
    throw new Error "getByPk must be redeclared"

  add: ->
    throw new Error "add must be redeclared"

  updateByPk: ->
    throw new Error "updateByPk must be redeclared"




module.exports = BaseDbCollection