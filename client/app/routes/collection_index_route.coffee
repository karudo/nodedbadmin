CollectionIndexRoute = Ember.Route.extend
  model: ({pageNum, pageSize}, transition)->
    path = transition.params.collection.path
    path = decodeURIComponent(path)
    @controllerFor('application').set 'curCollPath', path
    serverParams = {pageNum, pageSize}
    App.log 'before load', path, serverParams
    collection = App.Collection.getByPath(path)
    Ember.RSVP.hash(
      allCount: collection.count()
      content: collection.query(serverParams)
    ).then (result)=>
      App.log 'after load', path, result.allCount
      {content, allCount} = result
      content.setProperties
        headers: _.keys(content.get('firstObject'))
        allCount: allCount
      content
      #result.headers = _.keys result.content[0]
      #result.content = result.content
      #Ember.ArrayProxy.create result


  actions:
    queryParamsDidChange: ->
      @refresh()


module.exports = CollectionIndexRoute