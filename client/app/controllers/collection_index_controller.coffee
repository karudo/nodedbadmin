
module.exports = Ember.ArrayController.extend
  queryParams: ['pageNum', 'pageSize']
  pageNum: 1
  pageSize: 25

  acont: (->
    cont = @get 'content'
    headers = @get 'content.headers'
    cont.map (v)->
      content = for h in headers
        v[h] or ''
      Em.ArrayProxy.create
        content: content
        pk: v.id
  ).property 'content', 'content.headers'
  actions:
    premoveRow:->
      @deleteByPk
