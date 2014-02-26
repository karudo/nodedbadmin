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

  valueDidChanged: (name)->
    @changedFields or= {}
    @changedFields[name] = yes
    @set 'valuesChanged', yes

  goBack: ->
    tr = @get('controllers.application.lastCollectionIndexTransition')
    if tr
      tr.retry()
    else
      @transitionToRoute('collection')

  actions:
    save: ->
      newVals = {}
      for k in _.keys @changedFields
        newVals[k] = @get "model.#{k}"
      App.Collection.getByPath(@get('collectionPath')).updateByPk(@get('pk'), newVals).then =>
        @changedFields = {}
        @set 'valuesChanged', no
        @goBack()
    cancel: ->
      @changedFields = {}
      @set 'valuesChanged', no
      @goBack()

     #App.log @changedFields, @modelOrig, @get 'model.name'