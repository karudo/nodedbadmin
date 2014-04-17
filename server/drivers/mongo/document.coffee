MongoCollection = require './mongo_collection'
{ObjectID} = require('mongodb')
{intval, keys, isArray} = nodedbadmin.utils._
{denodeifyExec} = nodedbadmin.promise

isValidObjectID = (str)->
  str = str + ''
  len = str.length
  valid = no
  if len is 12 or len is 24
    valid = /^[0-9a-fA-F]+$/.test(str)
  valid

class MongoDocumentCollection extends MongoCollection
  @configure 'MongoDocumentCollection'


  constructor: ->
    super
    @databaseName = @path[0].query
    @collectionName = @path[1].query


  getStructure: (pk)->
    @getResolvedPromise
      fields: no
      pkFields: '_id'
      features:
        addItem: no
        updateItem: yes
        deleteItem: yes


  getCollection: ->
    @connect(@databaseName).then (db)=>
      #@once 'destroy', -> db.close()
      denodeifyExec(db.collection, db, @collectionName)


  count: (params)->
    @getCollection().then (coll)=>
      denodeifyExec(coll.count, coll)


  query: (params)->
    pageNum = intval params.pageNum
    pageSize = intval params.pageSize
    @getCollection().then (coll)=>
      cursor = coll.find {}
      if isArray(params.sort) and params.sort.length
        so = {}
        [sortBy, sortOrder] = params.sort[0]
        so[sortBy] = sortOrder
        cursor = cursor.sort so
      cursor = cursor.skip((pageNum-1)*pageSize).limit(pageSize)
      denodeifyExec(cursor.toArray, cursor)


  getByPk: (pk)->
    @getCollection().then (coll)=>
      _id = if isValidObjectID(pk) then ObjectID(pk) else pk
      denodeifyExec(coll.findOne, coll, {_id})


  updateByPk: (pk, fields)->
    @getCollection().then (coll)=>
      _id = if isValidObjectID(pk) then ObjectID(pk) else pk
      denodeifyExec(coll.update, coll, {_id}, {$set: fields})


  deleteByPk: (pk)->
    @getCollection().then (coll)=>
      _id = if isValidObjectID(pk) then ObjectID(pk) else pk
      denodeifyExec(coll.remove, coll, {_id})



module.exports = MongoDocumentCollection
