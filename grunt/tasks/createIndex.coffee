path = require 'path'
_s = require 'underscore.string'
module.exports = (grunt)->
  grunt.registerMultiTask 'createIndex', 'Create index task', ->
    destFileSrc = "#file created by script\nmodule.exports =\n"
    for filePath in @filesSrc
      fileName = path.basename(filePath, '.coffee')
      continue if fileName is 'index'
      continue if _s.strLeft(fileName, '_') is ''
      objName = _s.classify(fileName)
      destFileSrc += "  #{objName}: require '#{filePath.split('.coffee')[0]}'\n"

    destFileName = path.join @data.cwd, @data.dest
    grunt.log.writeln "Created file: #{destFileName}"
    grunt.file.write destFileName, destFileSrc
    yes
