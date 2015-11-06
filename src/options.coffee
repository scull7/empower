{
  contextToRoles
}     = require './defaults'

# parse :: Object -> Object
parse = (options) ->


  contextToRoles  = options.contextToRoles or contextToRoles
  roleMap         = options.roleMap
  pathMap         = options.pathMap


  if (typeof roleMap?.check) isnt 'function' or roleMap?.check.length isnt 3
    throw new TypeError 'roleMap option must have a "check" function'

  if typeof pathMap?.getToken isnt 'function' or pathMap.getToken.length isnt 2
    throw new TypeError 'pathMap option must have a "getToken" function'

  if (typeof contextToRoles) isnt 'function' or contextToRoles.length < 2
    throw new TypeError 'contextToRoles option must be a function'

  return {
    contextToRoles  : contextToRoles
    roleMap         : roleMap
    pathMap         : pathMap
  }


module.exports  = parse
