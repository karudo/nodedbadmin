fs = require 'fs'
{join} = require 'path'
{denodeify, decallback, Promise} = require '../promise'

newFs =
  getUserHome: -> process.env.HOME or process.env.HOMEPATH or process.env.USERPROFILE
  existsPromise: decallback fs.exists

for key, value of fs
  newFs[key] = value
  if fs[key+'Sync'] and not newFs[key+'Promise']
    newFs[key+'Promise'] = denodeify value

newFs.mkdirFullPromise = (fullPath, mode = 0o700)->
  pathArr = fullPath.split '/'
  pathArr = pathArr.filter (el)-> ("#{el}").length > 0

  pathArr.reduce ((pr, dirName)->
    pr.then (curPath)->
      newPath = join curPath, dirName
      newFs.existsPromise(newPath).then (exists)->
        if exists
          newPath
        else
          newFs.mkdirPromise(newPath, mode).then ->
            newPath
  ), Promise.resolve('/')

module.exports = newFs