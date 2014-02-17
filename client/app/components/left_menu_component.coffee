LeftMenuComponent = Ember.Component.extend

  connectionChanged: (->
    defQuery = @get 'connection.defQuery'
    if defQuery
      @set 'dropDownItems', App.CollectionClass.connect(defQuery)
  ).observes('connection')

  actions:
    setSelectedDD: (item)->
      if item.defQuery
        @set 'listItems', App.CollectionClass.connect(item.defQuery)

module.exports = LeftMenuComponent