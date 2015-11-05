
parseOptions  = require './options'


# coalesce all of the role checks into a single value and pass it to the
# continuation function.
authHandlerFactory = (roleMap, token, method, done) -> (err, roles) ->
  if err then (done err) else
    done null, (roleMap.check roles, token, method)


empower = (options, ctx, path, method, done) ->
  try
    {
      contextToRoles
      roleMap
      pathMap
    }               = parseOptions options

    pathToken       = pathMap.getToken path, method
    contextToRoles ctx, (authHandlerFactory roleMap, pathToken, method, done)

  catch e
    done e


empower.authHandlerFactory  = authHandlerFactory


module.exports  = empower
