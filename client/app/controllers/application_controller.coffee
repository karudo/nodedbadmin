module.exports = Ember.Controller.extend
  appName: "nodedbadmin"

  actions:
    setSelectedConnection: (conn)->
      @set 'selectedConnection', conn
