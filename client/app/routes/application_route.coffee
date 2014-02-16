ApplicationRoute = Ember.Route.extend
  model: ->
    Ember.RSVP.hash
      connections: App.ConnectionCollection.connectPromise()

  setupController: (controller, models)->
    controller.setProperties(models)


module.exports = ApplicationRoute