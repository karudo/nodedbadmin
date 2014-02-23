module.exports = Ember.Controller.extend
  appName: "nodedbadmin"

  secondDropDownItems: (->
    pastureId = @get 'pastureId'
    if pastureId
      connections = @get 'connections'
      conn = connections.findBy 'id', pastureId
      if conn
        App.CollectionClass.connect conn.defQuery
  ).property 'pastureId', 'connections.@each'

  leftMenuItems: (->
    secondDropDownId = @get 'secondDropDownId'
    if secondDropDownId
      secondDropDownItems = @get 'secondDropDownItems'
      if secondDropDownItems and secondDropDownItems.get('length')
        ddItem = secondDropDownItems.findBy 'id', secondDropDownId
        if ddItem
          App.CollectionClass.connect ddItem.defQuery
  ).property 'secondDropDownId', 'secondDropDownItems.@each'

