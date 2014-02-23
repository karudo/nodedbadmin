ApplicationRoute = Ember.Route.extend
  model: (params, transition)->
    path = transition.params.collection?.path
    if path
      path = decodeURIComponent path
      [collProto, collPath] = path.split '#'
      [collNS, collId] = collProto.split ':'
      [firstItemPath] = collPath.split '/'
      [cn, sid] = firstItemPath.split ':'

    Ember.RSVP.hash
      connections: App.ConnectionCollection.connectPromise()
      pastureId: collId
      secondDropDownId: sid


  setupController: (controller, models)->
    controller.setProperties(models)


module.exports = ApplicationRoute