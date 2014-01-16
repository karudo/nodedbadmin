config = require './config'
{Server} = require './server'
server = new Server config
server.start()
#server.promise.get((resolve, reject)-> reject 1).then null, -> console.log 'qwe', arguments
#server._.clone(server)


