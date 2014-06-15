{MongoClient} = require 'mongodb'
{BaseDbCollection} = nodedbadmin.classes
{denodeify} = nodedbadmin.promise
{logger} = nodedbadmin

connectPromise = denodeify(MongoClient.connect, MongoClient)
promises = {}


class MongoCollection extends BaseDbCollection
  @configure 'MongoCollection'
  connect: (dbname = "")->
    port = @driver.pasture.port or 27017
    url = "mongodb://#{@driver.pasture.host}:#{port}/#{dbname}"
    unless promises[url]
      promises[url] = connectPromise(url)
    promises[url]


module.exports = MongoCollection