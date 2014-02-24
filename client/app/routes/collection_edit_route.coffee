CollectionEditRoute = Ember.Route.extend
  model: ({pk}, transition)->
    {path} = transition.params.collection
    path = decodeURIComponent path

    App.Collection.getByPath(path).getByPk(pk)

  #setupController: (controller, params)->
    #App.log '!!!!!!!!!!', controller, params
    #controller.set 'pk', params.pk

module.exports = CollectionEditRoute