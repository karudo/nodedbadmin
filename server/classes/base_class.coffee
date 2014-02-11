{EventEmitter} = require 'events'
{clone, isFunction, extend} = require '../utils/_'
{Promise} = promise = require '../promise'



class BaseClass extends EventEmitter
  _bc: ['BaseClass']

  @configure: (className)->
    @::_bc = clone @::_bc
    @::_bc.push className
  @getClassName: -> @::_bc[@::_bc.length - 1]

  @getLabel: (label)-> @::_bc.join(':') + if label then "##{label}" else ''

  @getPromise: (func, label)->
    new Promise func, @getLabel(label)


  getLabel: (label)-> @_bc.join(':') + if label then "##{label}" else ''

  getPromise: (func, label)->
    new Promise func, @getLabel(label)

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
