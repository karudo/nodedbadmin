path = require 'path'
promise = require './server/promise'
_ = require './server/utils/_'


arr = [

]

x =  _.chain(arr).pluck('id').map((v)-> _.intval v.replace('pas', '')).max().value()
if x > 0
  console.log x+1






