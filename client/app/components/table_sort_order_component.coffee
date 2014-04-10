module.exports = Ember.Component.extend
  tagName: 'span'
  classNames: ['arrow', 'glyphicon']
  classNameBindings: ['glyphiconSortByAttributes', 'glyphiconSortByAttributesAlt']

  glyphiconSortByAttributes: (->
    @get('col') is @get('sortBy') and @get('sortOrder') is 'asc'
  ).property 'col', 'sortBy', 'sortOrder'

  glyphiconSortByAttributesAlt: (->
    @get('col') is @get('sortBy') and @get('sortOrder') is 'desc'
  ).property 'col', 'sortBy', 'sortOrder'

  isVisible: (->
    @get('col') is @get('sortBy')
  ).property 'col', 'sortBy'