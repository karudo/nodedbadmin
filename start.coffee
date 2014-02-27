config = require './config'
{Server} = require './server'
server = new Server config
server.start().then ->

