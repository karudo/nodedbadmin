CollectionEditRoute = Ember.Route.extend

  setupController: (controller, params)->

    controller.set 'pk', params.pk

module.exports = CollectionEditRoute