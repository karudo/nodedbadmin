BaseCollection = require './base_collection'
{join} = require 'path'
{isString} = require '../utils/_'

class Pasture extends BaseCollection
  @configure 'Pasture'

  structure:
    id:
      type: 'string'
      canEdit: no
    name: 'string'
    driver:
      type: 'string'
      canEdit: no
      #type: 'foreignKey'
      #fkCollection: 'drivers'
      #fkFullPath: 'system#drivers'
    host: 'string'
    user: 'string'
    password: 'string'


  mapArr: (arr)->
    arr.map (i)->
      i.driverPath = "pastures:#{i.id}"
      i.defPath = "#{i.driverPath}#databases"
      i

  makePk: (idx, item)-> "pasture#{idx}"





module.exports = Pasture