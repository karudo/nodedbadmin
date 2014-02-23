CollectionIndexRoute = Ember.Route.extend
  model: ({pageNum, pageSize}, transition)->
    path = transition.params.collection.path
    path = decodeURIComponent(path)
    serverParams = {pageNum, pageSize}
    console.log new Date()+' before load', path, serverParams
    Ember.RSVP.hash(
      allCount: App.server.execCollectionMethod(path, 'count')
      content: App.server.execCollectionMethod(path, 'query', serverParams)
    ).then (result)=>
      console.log new Date()+' after load', path, result.allCount
      @controllerFor('application').set 'curCollPath', path
      result.headers = _.keys result.content[0]
      result.content = result.content.map (i)-> _.values(i)
      Ember.ArrayProxy.create result


  actions:
    queryParamsDidChange: ->
      @refresh()


module.exports = CollectionIndexRoute