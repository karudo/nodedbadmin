BaseCollection = require './base_collection'
{join} = require 'path'

class Pasture extends BaseCollection
  @configure 'Pasture'

  constructor: (@configPath)->
    @fromArray require join @configPath, 'pastures'


  makeId: (idx, item)-> "pasture#{idx}"





module.exports = Pasture