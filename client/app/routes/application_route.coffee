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
      connections: coll.query()
      pastureId: collId
      secondDropDownId: sid
      curCollPath: path


  setupController: (controller, models)->
    controller.setProperties(models)


module.exports = ApplicationRoute