ApplicationRoute = Ember.Route.extend
  model: (params, transition)->
    path = transition.params.collection?.path
    if path
      path = decodeURIComponent path
      [collProto, collPath] = path.split '#'
      [collNS, collId] = collProto.split ':'
      [firstItemPath] = collPath.split '/'
      [cn, sid] = firstItemPath.split ':'

    coll = App.Collection.getByPath('system#pastures')
    #coll.getStructure().then -> App.log arguments
    Ember.RSVP.hash
      connections: coll.cachedQuery()
      pastureId: collId
      secondDropDownId: sid
      curCollPath: path


  setupController: (controller, models, transition)->
    models.firstRoute = transition.targetName
    controller.setProperties(models)


module.exports = ApplicationRoute