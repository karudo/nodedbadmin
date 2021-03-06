_ = require 'lodash'
path = require 'path'
module.exports = (grunt)->

  config = _.extend({}, require("load-grunt-config")(grunt,
    configPath: path.join(__dirname, "grunt/options")
    loadGruntTasks: false
    init: false
  ))

  config.env = process.env

  grunt.loadNpmTasks 'grunt-ember-templates'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  #grunt.loadNpmTasks 'grunt-browserify2'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-less'

  grunt.loadTasks 'grunt/tasks'

  grunt.registerTask 'copyFilesDebug', ['copy:htmlDebug', 'copy:vendors']
  grunt.registerTask 'copyFilesDist', ['copy:htmlDist', 'copy:vendors']

  grunt.registerTask 'compileAll', ['emberTemplates', 'buildScripts', 'buildLess']

  grunt.registerTask 'default', "Build (in debug mode)", ['compileAll', 'copyFilesDebug']
  grunt.registerTask 'buildLess', ['less']
  grunt.registerTask 'buildTemplates', ['emberTemplates:debug']
  grunt.registerTask 'buildScripts', ['clean:tmp', 'createIndex', 'coffee', 'browserify']
  grunt.registerTask 'develop', ['default', 'watch']
  grunt.registerTask 'dist', 'Build dist', ['compileAll', 'copyFilesDist']


  grunt.initConfig(config)
