module.exports = Ember.Component.extend


  value: (->
    hash = @get 'hash'
    key = @get 'key'
    hash[key]
  ).property 'hash', 'key'
