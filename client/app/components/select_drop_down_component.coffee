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
  defaultName: 'select'
  actions:
    toggleMenu: ->
      @toggleProperty 'isOpen'
      no
    selectItem: (item)->
      @sendAction 'action', item
      @setProperties
        selectedId: item.id
        isOpen: no
      no
  selectedName: (->
    selectedId = @get 'selectedId'
    items = @get 'items'
    if selectedId and items.get 'length'
      items.findBy('id', selectedId).get 'name'
  ).property 'selectedId', 'items.@each'

module.exports = SelectDropDownComponent
