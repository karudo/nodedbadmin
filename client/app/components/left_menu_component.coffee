LeftMenuComponent = Ember.Component.extend
  classNames: ['left-menu']

  curPathDidChange: (->
    curPath = @get 'curPath'
    @get('items').forEach (it)-> it.set 'active', it.defQuery == curPath
  ).observes 'curPath', 'items.@each'


module.exports = LeftMenuComponent