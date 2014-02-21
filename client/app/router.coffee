#Router = Ember.Router.extend() # ensure we don't share routes between all Router instances
App.Router.map ->
  @resource 'collection', {path: '/collection/:query'}


# this.resource('posts', function() {
#   this.route('new');
# });
#module.exports = Router