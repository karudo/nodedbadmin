BaseClass = require './base_class'


class BaseDbCollection extends BaseClass
  @configure 'BaseDbCollection'

  #@getInitFunction: (pathStep, path)->
  #  (conn)-> console.log 'conn', conn, pathStep, path, path.indexOf pathStep


  constructor: (params)->
    if params.pathQuery
      @pathQuery = params.pathQuery
    if params.conn
      @conn = params.conn
    if params.path
      @path = params.path

  getConn: -> @getSettledPromise(@conn, @conn)

  query: (params)->
    throw new Error "query must be redeclared"




module.exports = BaseDbCollection