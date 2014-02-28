rsvp = require 'rsvp'

#rsvp.configure 'instrument', yes
#rsvp.on 'rejected', (event)-> console.log 'rejected', event

class Promise extends rsvp.Promise


decallback = (clbFunc, binding)->
  (argsOrig...)->
    thisArg = @ or binding
    new Promise (resolve, reject) ->
      try
        argsOrig.push (args...)->
          if args.length > 1
            resolve args
          else
            resolve args[0]
        clbFunc.apply thisArg, argsOrig
      catch e
        reject e


denodeify = (nodeFunc, binding) ->
  (argsOrig...)->
    thisArg = @ or binding
    new Promise (resolve, reject) ->
      try
        argsOrig.push (err, args...)->
          if err
            reject err
          else if args.length > 1
            resolve args
          else
            resolve args[0]
        nodeFunc.apply thisArg, argsOrig
      catch e
        reject e


defer = (label) ->
  deferred = {}
  deferred.promise = new Promise((resolve, reject) ->
    deferred.resolve = resolve
    deferred.reject = reject
  , label)
  deferred



module.exports = {Promise, denodeify, decallback, defer}