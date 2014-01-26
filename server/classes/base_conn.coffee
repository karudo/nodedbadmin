BaseClass = require './base_class'

class BaseConn extends BaseClass
  @configure 'BaseConn'


  close: -> throw @getError('must be redeclarated')


module.exports = BaseConn