ApplicationRoute = Ember.Route.extend
  model: ->
    Ember.RSVP.hash
      connections: App.ConnectionCollection.connect()

  setupController: (controller, models)->
    controller.setProperties(models)


module.exports = ApplicationRoute