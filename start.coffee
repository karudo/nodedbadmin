config = require './config'
{Server} = require './server'
server = new Server config
server.start()
#console.log server
#rsvp = require 'rsvp'
#rsvp.configure('instrument', true);
#rsvp.on 'created', -> console.log 'rfrfrf', arguments
#rsvp.on 'rejected', -> console.log 'qwedsa', arguments
#p = new rsvp.Promise (-> throw new Error {qwe:1111}), {a: 'labelle', b: 998}
#console.log p
#asd = rsvp.Promise.resolve(6767)
#p.then -> console.log arguments
#p.then(-> 77).then(-> console.log arguments)

