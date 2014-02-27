BaseClass = require './base_class'


class GlobalObject extends BaseClass
  classes: require '../classes'
  promise: require '../promise'
  utils:
    _: require '../utils/_'
    fs: require '../utils/fs'

  constructor: (vars)->
    if vars
      for k, v of vars
        @[k] = v



module.exports = GlobalObject