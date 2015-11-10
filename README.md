[![Build Status](https://travis-ci.org/scull7/privilege.svg?branch=master)](https://travis-ci.org/scull7/privilege)
[![Coverage Status](https://coveralls.io/repos/scull7/privilege/badge.svg?branch=master&service=github)](https://coveralls.io/github/scull7/privilege?branch=master)

# privilege
Give your users a sense of privilege with role based permissions.

### Mapping URLs to Permission Tokens

This is a mapping from a express compatible URL match string to a permission
token that will be used for role -> permission lookup. This is used to map
URLs to a route-permission key.

### Mapping Roles to Permission Tokens and Methods

This is a mapping of roles to permission tokens and the CRUD _(using their
HTTP method names)_ action permissions.

### Options

#### pathMap _(required)_

This required option must be a an object with a `getToken/1` method.  It will
be called with the path _(2nd argument to the `privilege` function)_, and it
should return a string.   You can build a proper object by using the
`privilege.PermissionMap.fromJson/1` function.   If you use the provided
PermissionMap builder then you may specify your paths using the same syntax
you would use for `express` router paths.

Example:
```javascript
var map = {
  '/test/path/:id': 'test:path',
  '/test/path/two/:id': 'test:path:two'
};

var options = {
  pathMap: privilege.PermissionMap.fromJson(map)
};
```

#### roleMap _(required)_

This required option must an object with a `check/3` method.  It will be
called with the token _(retrieved from the `geteToken/1` call)_, the list of
user role strings and the current request HTTP Method _(GET, POST, PUT,
DELETE...)_.  You can build a proper object by using the
`privilege.roleMap.fromJson/1` method.  

If you use the provided `roleMap` builder then you may specify your token to
permissions as follows:

```javascript
var map =  {
  'role': {
    'token1': [ 'get' ],
    'token2': [ 'get', 'post' ],
    'token3': [ 'put', 'delete' ]
  }
};
```

#### contextToRoles _(optional)_

This optional option must be a function with the following signature:
```
# contextToRoles :: Object -> (Error -> Array String -> Nil) -> Nil
```

It will be passed the context _(`ctx`)_ object and privilege expects the
provided callback to receive possibly an Error object and a list of role
strings. If you do not provide your own object then a function similar to the
following function will be used:

```javascript
function contextToRoles(context, done) {
  if (!context.user) {
    return done(new Error('context_user_required'));
  }
  if (!context.user.roles) {
    return done(new Error('context_user_roles_required'));
  }
  return done(null, context.user.roles);
}
```

The following error strings may be returned by this function:
```json
// Object keys are the possible error strings.
{
  "context_required": "context parameter is a falsy value.",
  "context_invalid": "context parameter is not an Object.",
  "context_user_required": "context.user is a falsy value.",
  "context_user_invalid": "context.user is not an object.",
  "context_user_roles_required": "context.user.roles is a falsy value.",
  "context_user_roles_invalid": "context.user.roles is not an Array."
}
```

### Usage

```javascript

var pathToTokenMap  = {
  '/test/path/:id': 'test:path',
  '/test/path/:id/action': 'test:path:action',
  '/test/other/:id/two': 'test:other:two',
  '/test/more/stuff': 'test:stuff',
  '/test/stuff': 'test:stuff'
};

var roleToTokenMap  = {
  'role-one': {
    'test:path': [ 'get' ],
    'test:path:action': [ 'post', 'put' ],
    'test:other:two': [ 'get', 'post', 'delete' ],
    'test:stuff': [ 'get', 'post', 'put' ]
  },
  'role-two': {
    'test:path': [ 'get' ],
    'test:other:two': ['get' ],
    'test:stuff': [ 'get', 'put', 'delete' ]
  }
};

var privilege = require('privilege')({
  pathMap: Privilege.PermissionMap.fromJson(pathToTokenMap),
  roleMap: Privilege.roleMap.fromJson(roleToTokenMap)
  // You can override the user role context lookup
  // by providing your own function.
  //contextToRoles: function(ctx, done) { done(null, [ 'my-role']); }
});

// This could be a request object.
var ctx  = {
  user: { roles: [ 'role-one' ] }
};

privilege(ctx, '/test/path/123/action', 'post', function(err, allowed) {
  // will output "true"
  console.log("user can access: ", allowed);
})

privilege(ctx, '/test/path/123', 'post', function(err, allowed) {
  // will output "false"
  console.log("user can access: ", allowed);
})

privilege(ctx, '/test/path/123', 'get', function(err, allowed) {
  /// will output "true"
  console.log("user can access: ", allowed);
})

```
