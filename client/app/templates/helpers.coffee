hb = Ember.Handlebars
{isNull} = _
{SafeString} = hb

hb.helper 'showValue', (v)->
  if isNull v
    new SafeString '<span class="null">NULL</span>'
  else
    v
