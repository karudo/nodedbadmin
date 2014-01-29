_ = require 'lodash'
path = require 'path'
module.exports = (grunt)->

  config = _.extend({}, require("load-grunt-config")(grunt,
    configPath: path.join(__dirname, "grunt/options")
    loadGruntTasks: false
    init: false
  ))
  console.log config

  config.env = process.env

  grunt.loadNpmTasks 'grunt-ember-templates'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  #grunt.loadNpmTasks 'grunt-concat-sourcemap'
  grunt.loadNpmTasks 'grunt-browserify2'

  grunt.registerTask 'copyFiles', ['copy:html', 'copy:vendors']

  grunt.registerTask 'default', "Build (in debug mode) & test your application.", ['emberTemplates', 'buildScripts', 'copyFiles']
  grunt.registerTask 'buildTemplates', ['emberTemplates:debug']
  grunt.registerTask 'buildScripts', ['coffee', 'browserify2', 'copy:appjs2public']


  grunt.initConfig(config)
