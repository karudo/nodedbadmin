CollectionItem = Ember.Object.extend
  encDefQuery: (-> encodeURIComponent @get 'defQuery').property('defQuery')

module.exports = CollectionItem

