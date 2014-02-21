SelectDropDownComponent = Ember.Component.extend
  classNames: ['dropdown']
  classNameBindings: ['isOpen:open']
  handlerTagName: 'a'
  handlerClassesComputed: (->
    classes = ['dropdown-toggle', 'pointer']
    if @get 'handlerClasses'
      classes = classes.concat @get('handlerClasses').split(' ')
    classes
  ).property 'handlerClasses'

  isOpen: no
  curName: 'select'
  actions:
    toggleMenu: ->
      @toggleProperty 'isOpen'
      no
    selectItem: (item)->
      @sendAction 'action', item
      @setProperties
        curName: item.name
        isOpen: no
      no

module.exports = SelectDropDownComponent
