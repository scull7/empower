
assert    = require 'assert'
Empower   = require '../../src/index.coffee'

testPerms =
  '/test/path/:id': 'test:path'
  '/test/path/:id/action': 'test:path:action'
  '/test/other/:id/two': 'test:other:two'
  '/test/more/stuff': 'test:stuff'
  '/test/stuff': 'test:stuff'

testRoles =
  'role-one':
    'test:path': [ 'get' ]
    'test:path:action': [ 'post', 'put' ]
    'test:other:two': [ 'get', 'post', 'delete' ]
    'test:stuff': [ 'get', 'post', 'put' ]
  'role-two':
    'test:path': [ 'get' ]
    'test:other:two': ['get' ]
    'test:stuff': [ 'get', 'put', 'delete' ]
  'role-three':
    '*': ['get', 'post', 'put', 'delete']

testPathMap = Empower.PermissionMap.fromJson testPerms
testRoleMap = Empower.RoleMap.fromJson testRoles

empower   = Empower
  pathMap : testPathMap
  roleMap : testRoleMap

ctx1      =
  user: roles: ['role-one']

ctx2      =
  user: roles: ['role-two']

ctx3      =
  user: roles: ['role-one', 'role-two']

ctx4      = 
  user: roles: ['role-three']

describe 'Empower Index', ->

  it 'should allow allow role-one "get" access on "/test/path/:id" ', (done) ->

    empower ctx1, '/test/path/123', 'get', (err, allowed) ->
      done try
        assert.equal err, null
        assert.equal allowed, true
        null
      catch e
        e


  it 'should not allow role-two "post" access on "/test/path/:id/action"',
  (done) ->

    empower ctx2, '/test/path/456/action', 'post', (err, allowed) ->
      done try
        assert.equal err, null
        assert.equal allowed, false
        null
      catch e
        e


  it 'should allow combined role user to "delete" on "/test/stuff"', (done) ->

    empower ctx3, '/test/stuff', 'delete', (err, allowed) ->
      done try
        assert.equal err, null
        assert.equal allowed, true
      catch e
        e


  it 'should allow role-three to "put" on "/test/stuff" or any other routes', (done) ->

    empower ctx4, '/test/stuff', 'put', (err, allowed) ->
      done try
        assert.equal err, null
        assert.equal allowed, true
      catch e
        e      


  it 'should allow combined role user to "post" on "/test/stuff"', (done) ->

    empower ctx3, '/test/stuff', 'post', (err, allowed) ->
      done try
        assert.equal err, null
        assert.equal allowed, true
      catch e
        e


  it 'should not allow role-two user to "post" on "/test/other/:id/two"',
  (done) ->

    empower ctx2, '/test/other/789/two', 'post', (err, allowed) ->
      done try
        assert.equal err, null
        assert.equal allowed, false
      catch e
        e


  it 'should not allow role-two user to "post" on "/test/more/stuff"',
  (done) ->

    empower ctx2, '/test/more/stuff', 'post', (err, allowed) ->
      done try
        assert.equal err, null
        assert.equal allowed, false
      catch e
        e


  it 'should allow combined role user to "post" on "/test/more/stuff"',
  (done) ->

    empower ctx3, '/test/more/stuff', 'post', (err, allowed) ->
      done try
        assert.equal err, null
        assert.equal allowed, true
      catch e
        e
