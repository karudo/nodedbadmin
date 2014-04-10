
module.exports = Ember.ArrayController.extend
  queryParams: ['pageNum', 'pageSize', 'sortBy', 'sortOrder']
  pageNum: 1
  pageSize: 50
  sortBy: no
  sortOrder: no

  acont: (->
    cont = @get 'content'
    headers = @get 'content.headers'
    pkFields = @get 'content.pkFields'
    cont.map (v)->
      Em.ArrayProxy.create
        content: (v[h] for h in headers)
        pk: v[pkFields]
  ).property 'content', 'content.headers', 'content.pkFields'

  actions:
    clickSort: (sortBy)->
      curSortBy = @get('sortBy')
      sortOrder = @get('sortOrder')
      if sortOrder is no
        sortOrder = 'asc'
      else
        if sortBy is curSortBy
          sortOrder = if sortOrder is 'asc' then 'desc' else 'asc'
        else
          sortOrder = 'asc'
      @transitionTo queryParams: {sortBy, sortOrder, pageNum: 1}

