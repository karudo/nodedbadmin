FormRow = Ember.Object.extend
  va: (->
    @valueDidChanged @get 'name'
  ).observes 'value'
  disabled: (->
    @hasOwnProperty('canEdit') and not @get('canEdit')
  ).property 'canEdit'

module.exports = Ember.Controller.extend
  needs: ['application']
  queryParams: ['pk']
  pk: no

  init: ->
    @_super()
    @set 'changedFields', new Ember.Set()

  showFields: (->
    fields = @get 'fields'
    return [] unless fields
    model = @get 'model'
    fields.map (v)=>
      v = _.clone v
      FormRow.create _.extend v,
        name: v.name
        model: model
        valueBinding: "model.#{v.name}"
        viewClass: App.EditView
        domId: "inputEdit-#{v.name}"
        valueDidChanged: @valueDidChanged.bind @
  ).property 'fields.@each'

  saveDisabled: (-> not @get 'valuesChanged').property 'valuesChanged'
  valuesChanged: (-> @get('changedFields.length') > 0).property 'changedFields.[]'

  valueDidChanged: (name)->
    @get('changedFields').add name

  goBack: ->
    tr = @get('controllers.application.lastCollectionIndexTransition')
    if tr
      tr.retry()
    else
      @transitionToRoute('collection')

  actions:
    save: ->
      newVals = {}
      for k in @get('changedFields.[]')
        newVals[k] = @get "model.#{k}"
      App.Collection.getByPath(@get('collectionPath')).updateByPk(@get('pk'), newVals).then =>
        @get('changedFields').clear()
        @goBack()
    cancel: ->
      @get('changedFields').clear()
      @goBack()

     #App.log @changedFields, @modelOrig, @get 'model.name'