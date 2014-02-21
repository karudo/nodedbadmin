module.exports = Ember.Component.extend
  arr: (-> _.values @get 'obj').property('obj')