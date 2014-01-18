BaseClass = require './baseclass'
Promise = require './promise'

util = require '../util'

clb = new BaseClass


class Deferred extends BaseClass
  @configure 'Deferred'
  @on: (event, func)-> clb.on event, func

  constructor: (@_info)->

  resolve: (args...)-> @resolveWith null, args...
  reject: (args...)-> @rejectWith null, args...
  resolveWith: (obj, args...)-> @_changeState 'resolved', obj, args
  rejectWith: (obj, args...)-> @_changeState 'rejected', obj, args

  promise: ->
    #@_promise or= new Promise @
    new Promise @

  done: (func)-> @_subs 'resolved', func
  fail: (func)-> @_subs 'rejected', func
  then: (d, f)->
    @done d if d
    @fail f if f
    @

  chainDone: (func)->
    d = new Deferred()
    @done =>
      retVal = @_exec 'resolved', func
      if retVal instanceof Deferred
        d.watch retVal
      else
        d.resolveWith @_obj, retVal
    d

  watch: (obj)->
    obj.done (args...)=> @resolveWith obj._obj, args...
    obj.fail (args...)=> @rejectWith obj._obj, args...
    @


  _changeState: (state, obj, args)->
    unless @state
      @state = state
      @_obj = obj
      @_args = args
      @emit "_callbacks_#{state}"
      @removeAllListeners()
      if state is 'rejected'
        clb.emit 'reject', @_info, args...
    @

  _exec: (type, func)->
    func.apply @_obj, @_args

  _subs: (type, func)->
    if @state
      if @state is type
        @_exec type, func
    else
      @once "_callbacks_#{type}", => @_exec type, func
    @

BaseClass._setDeferred Deferred



module.exports = Deferred