{
  contextToRoles
  pathToObjectId
  pathToObjectName
}     = require './defaults'

# parse :: Object -> Object
parse = (options) ->

  # @TODO ensure the user has provided all the proper maps

  contextToRoles    : options.contextToRoles or contextToRoles
  pathToObjectId    : options.pathToObjectId or pathToObjectId
  pathToObjectName  : options.pathToObjectName or pathToObjectName

  roleMap       : options.roleMap
  pathMap       : options.pathMap
  objectRoleMap : options.objectRoleMap

module.exports  = parse
