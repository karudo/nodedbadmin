module.exports = config: yes
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
###
