MongoCollection = require './mongo_collection'
{denodeifyExec} = nodedbadmin.promise


class MongoDatabaseCollection extends MongoCollection
  @configure 'MongoDatabaseCollection'


  query: ->
    @connect().then (db)=>
      adminDb = db.admin()
      denodeifyExec(adminDb.listDatabases, adminDb).then (list)=>
        list.databases.map (i)=>
          i.id = i.name
          i.defPath = @getPathStr(i.id, 'collections')
          i

module.exports = MongoDatabaseCollection
