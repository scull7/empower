
parseOptions  = require './options'

empower = (options, context, path, method, done) ->
  {
    contextToRoles
    pathToObjectId
    pathToObjectName
    roleMap
    pathMap
    objectRoleMap
  }               = parseOptions options

  pathToken       = pathMap.getToken path, method
  getObjectRoles  = objectRoleMap.getRoles.bind(
    null,
    (pathToObjectName objectName),
    context,
    (pathToObjectId ObjectId)
  )

  # pull the roles from the context and then combine any object roles
  contextToRoles context, (addObjectRoles checkRoles)


  # return a handler that will combine any given roles with any found
  # object roles
  addObjectRoles  = (cb) -> (err, roles) ->
    if err then (cb err) else getObjectRoles (err, objectRoles) ->
      if err then (cb err) else cb null, (roles.concat objectRoles)


  # coalesce all of the role checks into a single value and pass it to the
  # continuation function.
  checkRoles      = (err, roles) -> if err then (done err) else
    done null, (roleMap.check roles, pathToken)
