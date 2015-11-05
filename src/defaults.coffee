
# @TODO cover the case where ctx is an array.
contextToRoles    = (ctx, done) ->
  err = switch
    when not ctx then 'context_required'
    when typeof ctx isnt 'object' then 'context_invalid'
    when not ctx.user then 'context_user_required'
    when typeof ctx.user isnt 'object' then 'context_user_invalid'
    when not ctx.user.roles then 'context_user_roles_required'
    when not (Array.isArray ctx.user.roles)
      'context_user_roles_invalid'
    else null

  err = (new Error err) if err


  done(err, ctx?.user?.roles)


module.exports  =
  contextToRoles    : contextToRoles
