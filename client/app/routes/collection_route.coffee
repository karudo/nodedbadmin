CollectionRoute = Ember.Route.extend
  model: ({query:path, pageNum, pageSize})->
    path = decodeURIComponent(path)
    serverParams = {pageNum, pageSize}
    console.log new Date()+' before load', path, serverParams
    Ember.RSVP.hash(
      allCount: App.server.execCollectionMethod(path, 'count')
      content: App.server.execCollectionMethod(path, 'query', serverParams)
    ).then (result)->
      console.log new Date()+' after load', path, result.allCount
      result.headers = _.keys result.content[0]
      result.content = result.content.map (i)-> _.values(i)
      Ember.ArrayProxy.create result


  actions:
    queryParamsDidChange: ->
      @refresh()


module.exports = CollectionRoute