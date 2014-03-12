App = window.App = require './app'

App.server = require './server'

_.extend App, require './require'

require './templates/helpers'

require './router'
