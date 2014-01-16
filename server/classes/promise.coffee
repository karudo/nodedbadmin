rsvp = require 'rsvp'

BaseClass = require './baseclass'

class Promise extends BaseClass
  constructor: ->
    rsvp.configure 'instrument', on
    rsvp.on 'rejected', -> console.log arguments, 1111
  defer: (label)-> rsvp.defer label
  get: (func)-> new rsvp.Promise func

module.exports = Promise