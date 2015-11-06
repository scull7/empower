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
