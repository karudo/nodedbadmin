
module.exports = Ember.ArrayController.extend
  queryParams: ['pageNum', 'pageSize']
  pageNum: 1
  pageSize: 25

  acont: (->
    cont = @get 'content'
    headers = @get 'content.headers'
    pkFields = @get 'content.pkFields'
    cont.map (v)->
      content = for h in headers
        v[h] or ''
      Em.ArrayProxy.create
        content: content
        pk: v[pkFields]
  ).property 'content', 'content.headers'
