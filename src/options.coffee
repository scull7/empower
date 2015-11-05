{
  contextToRoles
}     = require './defaults'

# parse :: Object -> Object
parse = (options) ->

  contextToRoles  : options.contextToRoles or contextToRoles
  roleMap         : options.roleMap
  pathMap         : options.pathMap

  if typeof roleMap?.check isnt "function" or roleMap?.length isnt 3
    throw new TypeError 'roleMap option must have a "check" function'

  if typeof pathMap?.getToken isnt "function" or pathMap.length isnt 2
    throw new TypeError 'pathMap option must have a "getToken" function'

module.exports  = parse
