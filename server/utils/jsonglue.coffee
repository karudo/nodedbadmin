_ = window?._ or require 'lodash'
{isArray, isPlainObject, isDate} = _
###
  number
  string
  date
  bool
  blob
###

get_parent_and_obj_for = (obj, path, create = no)->
  parent = null
  key = null
  if path
    for next_key in path.split('.')
      next_key = parseInt(next_key, 10) if isArray obj
      parent = obj
      key = next_key
      if key and (typeof obj[key] is 'undefined')
        if create
          obj[key] = {}
        else
          return [null, null, null]
      obj = obj[next_key]
  [parent, key, obj]


get = (obj, path) ->
  #[parent, key, value] = get_parent_and_obj_for(obj, path, no)
  #value
  get_parent_and_obj_for(obj, path, no)[2]


set = (obj, path, value) ->
  [parent, key] = get_parent_and_obj_for(obj, path, yes)
  if parent
    parent[key] = value
  #else
  #  obj = value


getType = (obj)->
  if isDate obj
    'date'

JSONGlue =
  encode: (obj)->
    paths = {}
    walk = (curPath, curObj)->
      if isPlainObject(curObj) or isArray(curObj)
        _.each curObj, (newObj, key)->
          walk "#{curPath}.#{key}", newObj
      else
        if valueType = getType curObj
          paths[curPath.substr(1)] = valueType

    walk '', obj

    {
      value: obj
      schema: paths
    }

  decode: (obj)->
    value = obj.value
    if obj.schema
      _.each obj.schema, (type, path)->
        if type is 'date'
          v = get value, path
          set value, path, new Date(v)
    value


  encodeCollection: ->
  decodeCollection: ->




#module.exports = JSONGlue