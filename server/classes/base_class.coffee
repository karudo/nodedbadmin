{EventEmitter} = require 'events'
{clone, isFunction, extend} = require 'utils/_'
promise = require 'promise'
{Promise} = promise


promise.configure 'instrument', yes
promise.on 'rejected', (event)-> console.log 'rejected', event

mixins = require 'mixins'
console.log mixins

class BaseClass extends EventEmitter
  _bc: ['BaseClass']

  @configure: (className)->
    @::_bc = clone @::_bc
    @::_bc.push className
  @getClassName: -> @::_bc[@::_bc.length - 1]

  @mixin: (mixin)->
    extend @::, mixin::
    extend @, mixin


  getLabel: (label)-> @_bc.join(':') + if label then "##{label}" else ''

  getPromise: (a, b)->
    if isFunction b
      func = b
      label = @getLabel(a)
    else
      func = a
      label = @getLabel()
    new Promise func, label

  getResolvedPromise: (reason, label)-> Promise.resolve(reason, @getLabel(label))
  getRejectedPromise: (reason, label)-> Promise.reject(reason, @getLabel(label))
  getSettledPromise: (resolved, reason, label)->
    if resolved
      @getResolvedPromise(reason, label)
    else
      @getRejectedPromise(reason, label)

  isError: (e)-> e instanceof Error
  getError: (str)-> new Error str

  getEmptyPipeFunc: (a, b)->
    if isFunction a
      func = a
      exec = yes
    else
      func = b
      exec = a
    (reason)=>
      func reason if exec
      reason


  getFilterPipeFunc: (exec, func)->
    if exec
      func
    else
      (reason)-> reason


  log: (s)->
    @getEmptyPipeFunc (reason)=> console.log @_bc.join('::'), s, reason


module.exports = BaseClass
