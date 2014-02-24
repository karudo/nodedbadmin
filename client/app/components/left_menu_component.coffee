LeftMenuComponent = Ember.Component.extend
  classNames: ['left-menu']

  showItems: (->
    items = @get 'items'
    items.map (it)->
      it.set 'linkToParam', encodeURIComponent(it.get 'defPath')
      it
  ).property 'items.@each'

  curPathDidChange: (->
    curPath = @get 'curPath'
    @get('items').forEach (it)-> it.set 'active', it.defPath == curPath
  ).observes 'curPath', 'items.@each'


module.exports = LeftMenuComponent