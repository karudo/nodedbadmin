MongoCollection = require './mongo_collection'
{denodeifyExec} = nodedbadmin.promise


class MongoCollectionCollection extends MongoCollection
  @configure 'MongoCollectionCollection'

  constructor: ->
    super
    @dbName = @path[-2...-1][0].query


  query: ->
    @connect(@dbName).then (db)=>
      denodeifyExec(db.collectionNames, db).then (list)=>
        list.map (i)=>
          i.id = i.name.split("#{@dbName}.")[1]
          i.defPath = @getPathStr(i.id, 'documents')
          i



module.exports = MongoCollectionCollection