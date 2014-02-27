CollectionEditRoute = Ember.Route.extend

  model: ({pk}, transition)->
    {path} = transition.params.collection
    path = decodeURIComponent path
    coll = App.Collection.getByPath(path)
    if pk
      modelProm = coll.getByPk(pk)
      isExistsModel = yes
    else
      modelProm = {}
      isExistsModel = no
    Ember.RSVP.hash(
      model: modelProm
      structure: coll.getStructure()
    ).then ({model, structure})->
      _.extend structure,
        model: model
        modelOrig: _.clone(model)
        isExistsModel: isExistsModel
        collectionPath: path


  setupController: (controller, props)->
    controller.setProperties props


  actions:
    willTransition: (transition)->
      if @get('controller.valuesChanged') and confirm('Want to save changes?')
        transition.abort()
      else
        @get('controller.changedFields').clear?()
        yes


module.exports = CollectionEditRoute