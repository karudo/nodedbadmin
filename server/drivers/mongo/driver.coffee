{BaseDriver} = nodedbadmin.classes

MongoDatabaseCollection = require './database'
MongoCollectionCollection = require './collection'
MongoDocumentCollection = require './document'

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
          childs:
            documents:
              name: 'Documents'
              class: MongoDocumentCollection

  getSchema: -> @schema



module.exports = MongoDriver