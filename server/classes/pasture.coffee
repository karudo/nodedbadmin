BaseCollection = require './base_collection'
{join} = require 'path'

class Pasture extends BaseCollection
  @configure 'Pasture'

  constructor: (@configPath)->
    @fromArray require join @configPath, 'pastures'

  mapArr: (arr)->
    arr.map (i)->
      i.driverQuery = "pastures:#{i.id}"
      i.defQuery = "#{i.driverQuery}#databases"
      i

  makeId: (idx, item)-> "pasture#{idx}"





module.exports = Pasture