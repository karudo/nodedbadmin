CollectionEditRoute = Ember.Route.extend


  model: ({pk}, transition)->
    {path} = transition.params.collection
    path = decodeURIComponent path
    coll = App.Collection.getByPath(path)
    Ember.RSVP.hash
      model: coll.getByPk(pk)
      structure: coll.getStructure()
      collectionPath: path

  setupController: (controller, {model, structure, collectionPath}, transition)->
    controller.setProperties _.extend structure, {model, collectionPath, modelOrig: _.clone(model)}


  actions:
    willTransition: (transition)->
      if @get('controller.valuesChanged') and confirm('Want to save changes?')
        transition.abort()
      else
        yes


module.exports = CollectionEditRoute