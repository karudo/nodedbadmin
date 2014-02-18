module.exports = Ember.Controller.extend
  appName: "nodedbadmin"

  actions:
    connectionSelectorChanged: (conn)->
      @set 'selectedConnection', conn
      @set 'secondDropDownItems', App.CollectionClass.connect(conn.defQuery)
    secondDropDownItemsSelectorChanged: (item)->
      @set 'leftMenuItems', App.CollectionClass.connect(item.defQuery)

