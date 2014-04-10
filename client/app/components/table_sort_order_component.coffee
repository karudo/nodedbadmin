module.exports = Ember.Component.extend
  tagName: 'span'
  classNames: ['arrow', 'glyphicon']
  classNameBindings: ['glyphiconSortByAttributes', 'glyphiconSortByAttributesAlt']

  glyphiconSortByAttributes: (->
    @get('isVisible') and @get('sortOrder') is 'asc'
  ).property 'isVisible', 'sortOrder'

  glyphiconSortByAttributesAlt: (->
    @get('isVisible') and @get('sortOrder') is 'desc'
  ).property 'isVisible', 'sortOrder'

  isVisible: (->
    @get('col') is @get('sortBy')
  ).property 'col', 'sortBy'