BaseCollection = require './base_collection'
{join} = require 'path'
{isString, chain, intval, pluck} = require '../utils/_'

class Pasture extends BaseCollection
  @configure 'Pasture'

  structure:
    id:
      type: 'string'
      canEdit: no
    name: 'string'
    driver:
      type: 'drvselect'
      #canEdit: no
      #type: 'foreignKey'
      #fkCollection: 'drivers'
      #fkFullPath: 'system#drivers'
    host: 'string'
    port: 'string'
    user: 'string'
    password: 'string'


  mapArr: (arr)->
    arr.map (i)->
      i.driverPath = "pastures:#{i.id}"
      i.defPath = "#{i.driverPath}#databases"
      i


  makePk: (idx, item)->
    cur = chain(@_items).pluck(@pkFields).filter().map((v)-> intval v.replace('conn', '')).max().value()
    if cur < 0
      cur = 0
    cur++
    'conn' + cur






module.exports = Pasture