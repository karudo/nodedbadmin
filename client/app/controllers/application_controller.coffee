module.exports = Ember.Controller.extend
  appName: "nodedbadmin"

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

