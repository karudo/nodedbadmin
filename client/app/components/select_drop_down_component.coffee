SelectDropDownComponent = Ember.Component.extend
  classNames: ['dropdown']
  classNameBindings: ['isOpen:open']
  handlerTagName: 'a'
  handlerClassesComputed: (->
    classes = ['dropdown-toggle']
    if @get 'handlerClasses'
      classes = classes.concat @get('handlerClasses').split(' ')
    classes
  ).property 'handlerClasses'

  isOpen: no
  curName: 'select'
  actions:
    toggleMenu: ->
      @toggleProperty 'isOpen'
    selectItem: (item)->
      @sendAction 'action', item
      @setProperties
        curName: item.name
        isOpen: no

module.exports = SelectDropDownComponent
