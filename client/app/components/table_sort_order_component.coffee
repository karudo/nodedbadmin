{isArray} = _
module.exports = Ember.Component.extend
  tagName: 'span'
  classNames: ['arrow', 'glyphicon']
  classNameBindings: ['glyphiconSortByAttributes', 'glyphiconSortByAttributesAlt']

  glyphiconSortByAttributes: (->
    @get('isVisible') and @get('sortOrder') is 1
  ).property 'isVisible', 'sortOrder'

  glyphiconSortByAttributesAlt: (->
    @get('isVisible') and @get('sortOrder') is -1
  ).property 'isVisible', 'sortOrder'

  curSort: (->
    curSort = @get 'sort'
    if curSort.length
      unless isArray curSort[0]
        curSort[0] = curSort[0].split ','
    curSort
  ).property 'sort'

  sortBy: (->
    curSortBy = no
    curSort = @get 'curSort'
    if curSort.length
      [curSortBy] = curSort[0]
    curSortBy
  ).property 'sort'

  sortOrder: (->
    curSortOrder = 1
    curSort = @get 'curSort'
    if curSort.length
      curSortOrder = curSort[0][1]
    curSortOrder * 1
  ).property 'sort'

  isVisible: (->
    @get('col') is @get('sortBy')
  ).property 'col', 'sortBy'