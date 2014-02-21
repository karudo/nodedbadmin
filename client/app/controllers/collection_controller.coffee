
module.exports = Ember.ArrayController.extend
  queryParams: ['pageNum', 'pageSize']
  pageNum: 1
  pageSize: 25

  #contentChanged: (->
  #  console.log @get 'content.firstObject'
  #).observes 'content'
#  itemController: Ember.ArrayController.extend()