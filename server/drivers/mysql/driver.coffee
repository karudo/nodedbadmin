mysql = require 'mysql'
{BaseDriver} = nodedbadmin.classes
{denodeify} = nodedbadmin.promise

MysqlDatabaseCollection = require './database'
MysqlTableCollection = require './table'
MysqlTableRowCollection = require './table_row'


class MysqlDriver extends BaseDriver
  @configure 'MysqlDriver'
  schema:
    databases:
      name: 'Databases'
      class: MysqlDatabaseCollection
      childs:
        tables:
          name: 'Tables'
          class: MysqlTableCollection
          childs:
            rows:
              name: "Rows"
              class: MysqlTableRowCollection

  getSchema: -> @schema



module.exports = MysqlDriver