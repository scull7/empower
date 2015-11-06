{
  contextToRoles
}     = require './defaults'


assertFunction  = (objName, fnName, arity, obj) ->
  err = switch
    when not obj then "#{objName} option is required"
    when (typeof obj[fnName]) isnt 'function'
      "#{objName} option must have a '#{fnName}' function"
    when obj[fnName].length isnt arity
      "#{objName}.#{fnName} must have an arity of #{arity}"
    else null

  if err then throw new TypeError(err) else return obj


_validateRoleMap    = assertFunction.bind null, 'roleMap', 'check', 3
_validatePathMap    = assertFunction.bind null, 'pathMap', 'getToken', 1

_validateContextFn  = (fn) ->

  if (typeof fn) isnt 'function'
    throw new TypeError 'contextToRoles option must be a function'
  if fn.length < 2
    throw new TypeError 'contextToRoles must accept at least 2 arguments'

  return fn


# parse :: Object -> Object
parse = (options) ->

  roleMap     = _validateRoleMap options.roleMap
  pathMap     = _validatePathMap options.pathMap
  ctxToRoles  = _validateContextFn(
    if options.contextToRoles then options.contextToRoles else contextToRoles
  )

  return {
    contextToRoles  : ctxToRoles
    roleMap         : roleMap
    pathMap         : pathMap
  }


module.exports  = parse
