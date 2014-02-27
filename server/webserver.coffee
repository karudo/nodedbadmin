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



class Server extends BaseClass
  @start: (port = 3000)-> server.listen port


class Socket extends BaseClass
  @onUserConnect: (func)-> io.on 'connection', func

module.exports = {Socket, Server}
