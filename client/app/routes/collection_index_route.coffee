CollectionIndexRoute = Ember.Route.extend
  model: ({pageNum, pageSize}, transition)->
    path = transition.params.collection.path
    path = decodeURIComponent(path)
    serverParams = {pageNum, pageSize}
    App.log 'before load', path, serverParams
    Ember.RSVP.hash(
      allCount: App.server.execCollectionMethod(path, 'count')
      content: App.server.execCollectionMethod(path, 'query', serverParams)
    ).then (result)=>
      App.log 'after load', path, result.allCount
      @controllerFor('application').set 'curCollPath', path
      result.headers = _.keys result.content[0]
      result.content = result.content
      Ember.ArrayProxy.create result


  actions:
    queryParamsDidChange: ->
      @refresh()


module.exports = CollectionIndexRoute