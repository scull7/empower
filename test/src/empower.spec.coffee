
assert  = require 'assert'
empower = require '../../src/empower'

# A simple options container that provides mock stuffs
options =
  roleMap: { check: (roleList, token, method) -> null }
  pathMap: { getToken: (path, method) -> null }
  contextToRoles: (ctx, done) -> done()

describe 'Empower', ->

  it 'should be a function with an arity of 5', ->
    assert.equal empower.length, 5
    assert.equal (typeof empower), 'function'

  it 'should run through the authorization path: ' +
  ' (pathMap -> token) -> (ctx -> roles) -> (roleMap -> Bool)', (done) ->

    ctx = 'test'
    options.contextToRoles  = (ctx, cb) ->
      assert.equal ctx, 'test'
      cb null, [ 'test' ]

    options.roleMap.check   = (roleList, token, method) ->
      assert.deepEqual roleList, ['test']
      assert.equal token, 'pathToken'
      assert.equal method, 'get'
      return true

    options.pathMap.getToken  = (path, method) ->
      assert.equal path, 'test/path'
      assert.equal method, 'get'
      return 'pathToken'

    empower options, ctx, 'test/path', 'get', (err, isAllowed) ->
      if err then return (done err)

      assert.equal isAllowed, true
      done()

  it 'should propagate errors passed by the contextToRoles method', (done) ->

    ctx     = 'test'
    options =
      contextToRoles: (ctx, cb) -> (cb (new Error 'test-ctx-err'))
      pathMap: { getToken: (path, method) -> 'test:token' }
      roleMap: { check: (roleList, token, method) -> throw new Error('bad') }

    empower options, ctx, 'test/path', 'get', (err, isAllowed) ->
      assert.equal err.message, 'test-ctx-err'
      done()

  it 'should propagate a thrown error to the final callback', (done) ->

    ctx     = 'test'
    options =
      contextToRoles: (ctx, cb) -> throw new Error 'test-ctx-thrown-err'
      pathMap: { getToken: (path, method) -> 'test:token' }
      roleMap: { check: (roleList, token, method) -> throw new Error('bad') }

    empower options, ctx, 'test/path', 'get', (err, isAllowed) ->
      assert.equal err.message, 'test-ctx-thrown-err'
      done()
