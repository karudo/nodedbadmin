MongoCollection = require './mongo_collection'



class MongoDatabaseCollection extends MongoCollection
  @configure 'MongoDatabaseCollection'


  query: ->
    @connect().then (db)=>
      adminDb = db.admin()
      @getPromise (resolve, reject)=>
        adminDb.listDatabases (err, list)=>
          return reject err if err
          resolve list.databases.map (i)=>
            i.id = i.name
            i.defPath = @getPathStr(i.id, 'collections')
            i

module.exports = MongoDatabaseCollection
