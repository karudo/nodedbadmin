class BaseError extends Error
  @getClassName: -> 'BaseError'
  constructor: ({@reason, @classPath, @task})->
    super @reason

module.exports = BaseError