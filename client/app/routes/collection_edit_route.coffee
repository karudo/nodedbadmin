CollectionEditRoute = Ember.Route.extend
  model: ({pk}, transition)->
    {path} = transition.params.collection
    path = decodeURIComponent path

    App.Collection.getByPath(path).getByPk(pk)

  setupController: (controller, model, transition)->
    #o = o: -> console.log 777
    #model.addObserver 'name', o, 'o'
    @_super controller, model, transition
    {path} = transition.params.collection
    path = decodeURIComponent path
    App.Collection.getByPath(path).getStructure().then (s)->
      controller.setProperties s



module.exports = CollectionEditRoute