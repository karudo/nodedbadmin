{MongoClient} = require 'mongodb'
{BaseDbCollection} = nodedbadmin.classes
{denodeify} = nodedbadmin.promise
{logger} = nodedbadmin

connectPromise = denodeify(MongoClient.connect, MongoClient)


class MongoCollection extends BaseDbCollection
  @configure 'MongoCollection'
  connect: (dbname = "")->
    port = @driver.pasture.port or 27017
    url = "mongodb://#{@driver.pasture.host}:#{port}/#{dbname}"
    connectPromise(url)


module.exports = MongoCollection