{MongoClient} = require 'mongodb'
{BaseDbCollection} = nodedbadmin.classes
{denodeify} = nodedbadmin.promise
{logger} = nodedbadmin

connectPromise = denodeify(MongoClient.connect, MongoClient)


class MongoCollection extends BaseDbCollection
  @configure 'MongoCollection'
  connect: (dbname = "")->
    connectPromise "mongodb://#{@driver.pasture.host}:#{@driver.pasture.port}/#{dbname}"


module.exports = MongoCollection