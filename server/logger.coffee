colorize = do ->
  colors =
    white     : ['\x1B[37m', '\x1B[39m']
    grey      : ['\x1B[90m', '\x1B[39m']
    black     : ['\x1B[30m', '\x1B[39m']
    blue      : ['\x1B[34m', '\x1B[39m']
    cyan      : ['\x1B[36m', '\x1B[39m']
    green     : ['\x1B[32m', '\x1B[39m']
    magenta   : ['\x1B[35m', '\x1B[39m']
    red       : ['\x1B[31m', '\x1B[39m']
    yellow    : ['\x1B[33m', '\x1B[39m']

  (color, str)->
    if colors[color]
      "#{colors[color][0]}#{str}#{colors[color][1]}"
    else
      str

class Logger
  levels:
    debug: 4
    info: 3
    warn: 2
    error: 1

  colors:
    debug: 'grey'
    info: 'cyan'
    warn: 'yellow'
    error: 'red'

  constructor: (@curLevel)->
    @curLevelNum = @levels[@curLevel]

  @colorize: (color, str)->
    colorize color, str

  _log: (check, level, args...)->
    level = 'warn' unless level and @levels[level]
    return if check and @levels[level] > @curLevelNum
    curTime = (new Date).toTimeString().split(' ')[0]
    str = "[#{colorize(@colors[level], level)}]"
    str += " #{colorize('grey', curTime)} "
    console.log str, args...

  log: (args...)->
    @_log yes, args...

  logAll: (args...)->
    @_log no, args...

  debug: (args...)-> @log 'debug', args...
  info: (args...)-> @log 'info', args...
  warn: (args...)-> @log 'warn', args...
  error: (args...)-> @log 'error', args...


module.exports = Logger