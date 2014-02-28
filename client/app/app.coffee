AppClass = Ember.Application.extend
  LOG_ACTIVE_GENERATION: ENV.DEBUG
  LOG_MODULE_RESOLVER: ENV.DEBUG
  LOG_TRANSITIONS: ENV.DEBUG
  LOG_TRANSITIONS_INTERNAL: ENV.DEBUG
  LOG_VIEW_LOOKUPS: ENV.DEBUG

  log: ->
    if ENV.DEBUG
      console.error new Date()+'', arguments...

module.exports =  AppClass.create()