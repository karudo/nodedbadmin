CustomTagComponent = Ember.Component.extend
  attributeBindings: ['href']
  href: '#'
  init: ->
    @_super()
    classes = @get 'controller.classes'
    classNames = @get 'classNames'
    if classes and classNames
      @set 'classNames', classNames.concat classes
  click: ->
    @sendAction()


module.exports = CustomTagComponent