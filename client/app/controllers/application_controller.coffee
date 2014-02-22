module.exports = Ember.Controller.extend
  appName: "nodedbadmin"

  secondDropDownItems: (->
    pastureId = @get 'pastureId'
    if pastureId
      connections = @get 'connections'
      conn = connections.findBy 'id', pastureId
      App.CollectionClass.connect conn.defQuery
  ).property 'pastureId'

  leftMenuItems: (->
    secondDropDownId = @get 'secondDropDownId'
    if secondDropDownId
      secondDropDownItems = @get 'secondDropDownItems'
      ddItem = secondDropDownItems.findBy 'id', secondDropDownId
      if ddItem
        App.CollectionClass.connect ddItem.defQuery
  ).property 'secondDropDownId', 'secondDropDownItems.@each'

