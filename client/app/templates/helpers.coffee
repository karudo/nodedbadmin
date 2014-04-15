hb = Ember.Handlebars
{isNull} = _
{SafeString} = hb

hb.helper 'showValue', (v)->
  if isNull v
    new SafeString '<span class="null">NULL</span>'
  else
    v


do ->
  get = Ember.get
  EmberHandlebars = Ember.Handlebars
  EmberHandlebars.registerHelper "group", (options) ->
    data = options.data
    fn = options.fn
    view = data.view
    childView = view.createChildView(Ember._MetamorphView,
      context: get(view, "context")
      template: (context, options) ->
        options.data.insideGroup = true
        fn context, options
    )
    view.appendChild childView
    return
