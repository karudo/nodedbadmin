BaseClass = require './base_class'


class BaseDbCollection extends BaseClass
  @configure 'BaseDbCollection'

  constructor: (@driver, @path)->

  getPathStr: (curId, defColl)->
    "#{@driver.pathStr}#" + @path.map(({name, query})-> "#{name}:#{if query then query else curId}").join('/') + "/#{defColl}"

  query: (params)->
    throw new Error "query must be redeclared"




module.exports = BaseDbCollection