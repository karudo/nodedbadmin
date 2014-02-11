fs = require 'fs'
{denodeify} = require '../promise'

newFs = {}
for key, value of fs
  newFs[key] = value
  if fs[key+'Sync']
    newFs[key+'Promise'] = denodeify value

module.exports = newFs