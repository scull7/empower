

# contextToRoles :: Context -> (Error -> Array String) -> Nil
contextToRoles    = (context, done) -> if not context?.user?.roles
  done (new Error 'could not extract roles from the given context')
else
  done null, context.user.roles


# pathToObjectId :: String -> String
pathToObjectId    = (path) -> null


# pathToObjectName :: String -> String
pathToObjectName  = (path) -> ""

module.exports  =

  contextToRoles    : rolesFromContext
  pathToObjectId    : pathToObjectId
  pathToObjectName  : pathToObjectName
