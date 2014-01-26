MysqlDriver = require './driver'
MysqlDatabaseCollection = require './database'


module.exports =
  driver: MysqlDriver
  schema:
    databases:
      name: 'Databases'
      class: MysqlDatabaseCollection
      childs:
        tables:
          name: 'Tables'



