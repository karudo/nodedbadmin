rsvp = require 'rsvp'

rsvp.configure 'instrument', yes
rsvp.on 'rejected', (event)-> console.log 'rejected', event

class Promise extends rsvp.Promise




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



module.exports = {Promise, denodeify}