module.exports = Ember.Controller.extend
  appName: "nodedbadmin"
  #init: ->
    #console.log @
    #@set 'pastures'

  actions:
    setSelectedConnection: (conn)->
      @set 'selectedConnection', conn


