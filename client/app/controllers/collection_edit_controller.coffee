module.exports = Ember.ObjectController.extend
  queryParams: ['pk']
  pk: no



  showFields: (->
    fields = @get 'fields'
    return [] unless fields
    model = @get 'model'
    fields.map (v)->
      v = _.clone v
      v = _.extend v,
        name: v.name
        model: model
        valueBinding: "model.#{v.name}"
        viewClass: App.EditView
        domId: "inputEdit-#{v.name}"
        disabled: v.hasOwnProperty('canEdit') and !v.canEdit
      Ember.Object.create v
  ).property 'fields.@each'
