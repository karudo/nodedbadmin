BaseClass = require './classes/base_class'

{join} = require 'path'

io = require("socket.io")
express = require("express")

publicdir = join __dirname, '../public'
app = express()
app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.errorHandler { dumpExceptions: yes, showStack: yes }
app.get '/', (req, res)-> res.sendfile join publicdir, 'index.html'
app.use '/static', express.static publicdir

server = require("http").createServer(app)
io = io.listen(server)
io.set 'log level', 1
#io.on "connection", (socket)->
#  console.log socket
#  socket.on 'hui', ->
#    console.log 1111

server.listen 3000

class Server extends BaseClass


class Socket extends BaseClass
  @onUserConnect: (func)-> io.on 'connection', func

module.exports = {Socket, Server}
