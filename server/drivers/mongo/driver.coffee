{BaseDriver} = nodedbadmin.classes

MongoDatabaseCollection = require './database'
MongoCollectionCollection = require './collection'

class MongoDriver extends BaseDriver
  @configure 'MongoDriver'
  schema:
    databases:
      name: 'Databases'
      class: MongoDatabaseCollection
      childs:
        collections:
          name: 'Collections'
          class: MongoCollectionCollection

  getSchema: -> @schema



module.exports = MongoDriver