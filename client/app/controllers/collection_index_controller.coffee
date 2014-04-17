{isArray} = _
module.exports = Ember.ArrayController.extend
  queryParams: ['pageNum', 'pageSize', 'sort']
  pageNum: 1
  pageSize: 50
  sort: []

  acont: (->
    cont = @get 'content'
    headers = @get 'content.headers'
    pkFields = @get 'content.pkFields'
    cont.map (v)->
      Em.ArrayProxy.create
        content: (v[h] for h in headers)
        pk: v[pkFields]
  ).property 'content', 'content.headers', 'content.pkFields'

  headers: (->
    curSortBy = no
    headers = @get 'content.headers'
    curSort = @get 'sort'
    if curSort.length
      unless isArray curSort[0]
        curSort[0] = curSort[0].split ','
      [curSortBy] = curSort[0]
    headers.map (v)->
      name: v
      sorted: v is curSortBy
  ).property 'content.headers', 'sort'

  actions:
    clickSort: (sortBy)->
      curSort = @get 'sort'
      if curSort.length
        unless isArray curSort[0]
          curSort[0] = curSort[0].split ','
        [curSortBy, curSortDir] = curSort[0]
        if curSortBy is sortBy
          sort = [[sortBy, -1 * curSortDir]]
        else
          sort = [[sortBy, 1]]
      else
        sort = [[sortBy, 1]]
      @transitionTo queryParams: {sort, pageNum: 1}

