{EventEmitter} = require('events')
util = require '../util'

Deferred = null

class BaseClass extends EventEmitter
  _bc: ['BaseClass']
  @_setDeferred: (d)-> Deferred = d

  constructor: ->

  @configure: (s)->
    @::_bc = util.clone @::_bc
    @::_bc.push s

  @Deferred: (func)->
    d = new Deferred classPath: @::_bc
    if util.isFunction func
      func ((args...)-> d.resolve args...), ((args...)-> d.reject args...)
    d

  Deferred: (a, b)->
    if util.isFunction b
      func = b
      label = a
    else
      func = a
      label = null

    d = new Deferred classPath: @_bc, label: label
    if util.isFunction func
      func ((args...)-> d.resolve args...), ((args...)-> d.reject args...)
    d


module.exports = BaseClass
