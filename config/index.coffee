module.exports =
  configPath: __dirname
  logLevel: 'debug'
  webserverPort: 3000
###
class Type
  @code: (s)->
    console.log arguments
    @::.q = s

class Collection extends Type
  @code 'qwqwqw'

a = new Collection()
b = new Type()

console.log(a.q, b.q)

x =
  code: 'database'
  type: 'collection'
  value:
    code: 'table'
    type: 'collection'
    value:
      type: 'sqltable'

class BaseConnection
  @configure: (s, params)->
    super s
    @::_params = params

  constructor: (params)->
    @params = params if params


class BaseDriver

class MysqlDriver extends BaseDriver
  connect: ->

  select: (conn, params, resolve, reject)->
    promise.denodeify(conn.query)("SELECT 1")


  exec: (m)->
    #@getPromise (resolve, reject)
module.exports =
  databases:
    type: 'collection'
    name: 'DBs'
    class: MysqlDB
    childs:
      tables:
        type: 'collection'
        name: 'Tables'
        class: MysqlTy
        childs:
          rows:
            type: 'collection'
            name: 'Rows'

qwe.getChild('databases').then((DatabasesCollection)-> DatabasesCollection.getById('mysql'))
.then((Database)-> Database.getChild('tables'))
.then((TablesCollection)-> TablesCollection.getById('user'))
.then((Table)-> Table.getById(12))
###

