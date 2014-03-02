CollectionIndexRoute = Ember.Route.extend
  model: ({pageNum, pageSize}, transition)->
    @controllerFor('application').set 'lastCollectionIndexTransition', transition
    path = transition.params.collection.path
    path = decodeURIComponent(path)
    @controllerFor('application').set 'curCollPath', path
    serverParams = {pageNum, pageSize}
    App.log 'before load', path, serverParams
    collection = App.Collection.getByPath(path)
    Ember.RSVP.hash(
      allCount: collection.count()
      content: collection.query(serverParams)
      structure: collection.getStructure()
    ).then (result)=>
      App.log 'after load', path, result.allCount
      {content, allCount, structure} = result
      content.setProperties
        headers: structure.fields.map (f)-> f.name
        allCount: allCount
        collectionPath: path
      content


  actions:
    queryParamsDidChange: ->
      @refresh()
    removeRow: (pk)->
      if confirm 'Delete?'
        path = @get 'controller.content.collectionPath'
        App.Collection.getByPath(path).deleteByPk(pk).then =>
          @refresh()


module.exports = CollectionIndexRoute