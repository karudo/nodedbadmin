
class ChainInintableMixin



  getParent: -> @_parent
  setParent: (@_parent)->

  #default empty
  getInitFunction: ->


module.exports = ChainInintableMixin