pkg = require './package'
config = require './config'
{Server} = require './server'

cli = require("commander")
cli.version pkg.version
cli.option '-c, --config <path>', "Path to config dir. Default: #{config.configPath}"
cli.option '-n, --host <string>', "Webserver hostname. Default: #{config.webserverHost}"
cli.option '-p, --port <number>', "Webserver port. Default: #{config.webserverPort}"
cli.option '-l, --loglevel <string>', "Log level. Default: #{config.logLevel}"


cli.parse process.argv

if cli.config
  config.configPath = cli.config

if cli.host
  config.webserverHost = cli.host

if cli.port
  config.webserverPort = parseInt cli.port, 10

if cli.loglevel
  config.logLevel = cli.loglevel

server = new Server config
server.start().then (->
  server.logger.logAll 'info', "Started. Open http://#{config.webserverHost}:#{config.webserverPort} in your browser."
), (err)->
  server.logger.error 'error start', err

