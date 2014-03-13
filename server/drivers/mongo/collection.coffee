MongoCollection = require './mongo_collection'



class MongoCollectionCollection extends MongoCollection
  @configure 'MongoCollectionCollection'

  constructor: ->
    super
    @dbName = @path[-2...-1][0].query


  query: ->
    @connect(@dbName).then (db)=>
      @getPromise (resolve, reject)=>
        db.collectionNames (err, list)=>
          return reject err if err
          console.log list
          resolve list.map (i)=>
            i.id = i.name.split("#{@dbName}.")[1]
            i.defPath = @getPathStr(i.id, 'documents')
            i



module.exports = MongoCollectionCollection