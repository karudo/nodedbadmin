
module.exports = Ember.ArrayController.extend
  queryParams: ['pageNum', 'pageSize']
  pageNum: 1
  pageSize: 25

  acont: (->
    cont = @get 'content'
    headers = @get 'content.headers'
    pkFields = @get 'content.pkFields'
    cont.map (v)->
      Em.ArrayProxy.create
        content: (v[h] for h in headers)
        pk: v[pkFields]
  ).property 'content', 'content.headers', 'content.pkFields'
