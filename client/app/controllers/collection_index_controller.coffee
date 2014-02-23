
module.exports = Ember.ArrayController.extend
  queryParams: ['pageNum', 'pageSize']
  pageNum: 1
  pageSize: 25

  acont: (->
    cont = @get 'content'
    cont.map (v)->
      Em.ArrayProxy.create
        content: _.values v
        pk: v.id
  ).property 'content'
