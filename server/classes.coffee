fs = require 'fs'
{join} = require 'path'

classes = {}

files = fs.readdirSync join __dirname, './classes'
for f in files
  classObject = require join __dirname, './classes', f
  if classObject.getClassName
    className = classObject.getClassName()
    classes[className] = classObject

module.exports = classes
