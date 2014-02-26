util = require 'lodash'
util.intval = (v)->
  v = parseInt v, 10
  if isNaN v
    0
  else
    v
module.exports = util
