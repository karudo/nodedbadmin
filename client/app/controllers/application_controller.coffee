module.exports = Ember.Controller.extend
  appName: "nodedbadmin"

  errorOpen: no
  errorText: 'no error'

  firstEnterOpen: no
  emptyConntectionsOpen: (->
    @get('firstEnterOpen') and (@get('firstRoute') is 'index') and (@get('connections.length') < 1)
  ).property 'firstRoute', 'connections.@each', 'firstEnterOpen'

  init: ->
    @_super()
    setTimeout (=> @set 'firstEnterOpen', yes), 1500
    App.server.on 'error', (err)=>
      if err.reason
        @set 'errorText', err.reason
      else
        @set 'errorText', err
      @set 'errorOpen', yes

  secondDropDownItems: (->
    pastureId = @get 'pastureId'
    if pastureId
      connections = @get 'connections'
      conn = connections.findBy 'id', pastureId
      if conn
        App.Collection.getByPath(conn.defPath).queryModel()
  ).property 'pastureId', 'connections.@each'

  leftMenuItems: (->
    secondDropDownId = @get 'secondDropDownId'
    if secondDropDownId
      secondDropDownItems = @get 'secondDropDownItems'
      if secondDropDownItems and secondDropDownItems.get('length')
        ddItem = secondDropDownItems.findBy 'id', secondDropDownId
        if ddItem
          App.Collection.getByPath(ddItem.defPath).queryModel()
  ).property 'secondDropDownId', 'secondDropDownItems.@each'

  actions:
    closeError: -> @toggleProperty 'errorOpen'
    closeFirstEnter: -> @toggleProperty 'firstEnterOpen'

