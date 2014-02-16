LeftMenuComponent = Ember.Component.extend
  #init: ->
  #  @_super()

  connectionChanged: (->
    defQuery = @get 'connection.defQuery'
    if defQuery
      @set 'dropDownItems', App.CollectionClass.connect(defQuery)
  ).observes('connection')

  actions:
    setSelectedDD: (item)->
      if item.defQuery
        console.log item.defQuery
        @set 'listItems', App.CollectionClass.connect(item.defQuery)

module.exports = LeftMenuComponent