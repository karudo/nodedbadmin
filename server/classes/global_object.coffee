BaseClass = require './base_class'


class GlobalObject extends BaseClass
  classes: require '../classes'
  promise: require '../promise'
  utils:
    _: require '../utils/_'
    fs: require '../utils/fs'


module.exports = GlobalObject