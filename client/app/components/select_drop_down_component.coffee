SelectDropDownComponent = Ember.Component.extend
  classNames: ['dropdown']
  classNameBindings: ['isOpen:open']
  isOpen: no
  curName: 'select'
  actions:
    toggleMenu: ->
      @toggleProperty 'isOpen'
    selectItem: (pasture)->
      @sendAction 'action', pasture
      @setProperties
        curName: pasture.name
        isOpen: no

module.exports = SelectDropDownComponent