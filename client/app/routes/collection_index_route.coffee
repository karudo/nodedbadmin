{isArray} = _
CollectionIndexRoute = Ember.Route.extend
  model: ({pageNum, pageSize, sort}, transition)->
    @controllerFor('application').set 'lastCollectionIndexTransition', transition
    path = transition.params.collection.path
    path = decodeURIComponent(path)
    @controllerFor('application').set 'curCollPath', path
    sort = sort.map (v)->
      unless isArray v
        v = v.split ','
      if v.length > 1
        v[1] *= 1
      v
    serverParams = {pageNum, pageSize, sort}
    App.log 'before load', path, serverParams
    collection = App.Collection.getByPath(path)
    Ember.RSVP.hash
      allCount: collection.count()
      model: collection.query(serverParams)
      structure: collection.getStructure()
    .then (result)=>
      App.log 'after load', path, result.allCount
      {model, allCount, structure} = result
      #console.log 'ASASASASASASAS', structure, model
      if structure.fields
        headers = structure.fields.map (f)-> f.name
      else
        headers = _.union model.map((i)-> _.keys i)...
      model.setProperties
        headers: headers
        allCount: allCount
        pkFields: structure.pkFields
        features: structure.features
      {model, collectionPath: path}

  setupController: (controller, props)->
    controller.setProperties props


  actions:
    reload: ->
      @refresh()
    queryParamsDidChange: ->
      @refresh()
    removeRow: (pk)->
      if confirm 'Delete?'
        path = @get 'controller.collectionPath'
        App.Collection.getByPath(path).deleteByPk(pk).then =>
          @refresh()


module.exports = CollectionIndexRoute