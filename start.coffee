config = require './config'
{Server} = require './server'
server = new Server config
server.start().then ->
  #server.execCollectionMethod('pastures:pas0#databases:sergeant/tables:Periods/rows', 'query', []).then (a)-> console.log 77777, a
  ###
  server.getPasture('pas0').then (driver)->
    driver.getCollection('databases').then (coll)->
      console.log 1111, coll.getClassName()
      coll.query().then -> console.log 2222, arguments
  ###
#    driver.getCollection('databases:sergeant/tables:TestTable/rows').then (collection)->
#      collection.query().then -> console.log 's', arguments
      # console.log collection
      #collection.query().then -> console.log arguments




#rsvp.configure('instrument', true);
#rsvp.on 'created', -> console.log 'rfrfrf', arguments
#rsvp.on 'rejected', -> console.log 'qwedsa', arguments
#p = new rsvp.Promise (-> throw new Error {qwe:1111}), {a: 'labelle', b: 998}
#console.log p
#asd = rsvp.Promise.resolve(6767)
#p.then -> console.log arguments
#p.then(-> 77).then(-> console.log arguments)

#console.log 111