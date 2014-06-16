BaseClass = require './classes/base_class'

{join} = require 'path'

socket = require("socket.io")
express = require("express")
http = require("http")

promise = require './promise'

publicdir = join __dirname, '../public'


class Server extends BaseClass
  @start: (port, host)->
    @app = app = express()
    #app.configure ->
    #  app.use express.bodyParser()
    #  app.use express.methodOverride()
    #  app.use app.router
    #  app.use express.errorHandler { dumpExceptions: yes, showStack: yes }
    app.get '/', (req, res)-> res.sendfile join publicdir, 'index.html'
    app.use '/static', express.static publicdir

    @server = http.createServer(app)
    @sio = socket.listen(@server)
    @sio.set 'log level', 1

    defer = promise.defer()

    listenObj = @server.listen port, host
    listenObj.on 'listening', => defer.resolve(new Socket @sio)
    listenObj.on 'error', -> defer.reject("can't start webserver")

    defer.promise


class Socket extends BaseClass
  constructor: (@sio)->
  onUserConnect: (func)-> @sio.on 'connection', func

module.exports = {Socket, Server}
