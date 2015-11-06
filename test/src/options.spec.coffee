
assert  = require 'assert'
parse   = require '../../src/options'

describe 'Options Parser', ->

  it 'should throw a TypeError if roleMap is not set.', ->

    try
      options = parse
        pathMap: { getToken: (path, method) -> null }
    catch e
      assert.equal (e instanceof TypeError), true
      assert.equal e.message, 'roleMap option is required'


  it 'should throw a TypeError if roleMap.check is not a function', ->

    try
      options = parse
        roleMap: { check: 'foo' }
        pathMap: { getToken: (path, method) -> null }
    catch e
      assert.equal (e instanceof TypeError), true
      assert.equal e.message, 'roleMap option must have a \'check\' function'


  it 'should throw a TypeError if roleMap.check doesn\'t have an arity of 3',
  ->

    try
      options = parse
        roleMap: { check: (map, path) -> null }
        pathMap: { getToken: (path, method) -> null }
    catch e
      assert.equal (e instanceof TypeError), true
      assert.equal e.message, 'roleMap.check must have an arity of 3'

  it 'should throw a TypeError if pathMap is not set.', ->

    try
      options = parse
        roleMap: { check: (map, path, method) -> null }
    catch e
      assert.equal (e instanceof TypeError), true
      assert.equal e.message, 'pathMap option is required'


  it 'should throw a TypeError if pathMap.getToken is not a function', ->

    try
      options = parse
        roleMap: { check: (map, path, method) -> null }
        pathMap: { getToken: 'test' }
    catch e
      assert.equal (e instanceof TypeError), true
      assert.equal e.message, 'pathMap option must have a \'getToken\' function'


  it 'should throw a TypeError if pathMap.getToken does\'t have an arity of 3',
  ->

    try
      options = parse
        roleMap: { check: (map, path, method) -> null }
        pathMap: { getToken: (path) -> null }
    catch e
      assert.equal (e instanceof TypeError), true
      assert.equal e.message, 'pathMap option must have a "getToken" function'

  it 'should provide a default contextToRoles option', ->

    options = parse
      roleMap: { check: (map, path, method) -> null }
      pathMap: { getToken: (path) -> null }

    assert.equal (typeof options.contextToRoles), 'function'

  it 'should throw a type error if contextToRoles is not a function', ->

    try
      options = parse
        roleMap: { check: (map, path, method) -> null }
        pathMap: { getToken: (path) -> null }
        contextToRoles: 'foo'
    catch e
      assert.equal (e instanceof TypeError), true
      assert.equal e.message, 'contextToRoles option must be a function'


  it 'should throw a TypeError if contextToRoles has an arity < 2', ->

    try
      options = parse
        roleMap: { check: (map, path, method) -> null }
        pathMap: { getToken: (path) -> null }
        contextToRoles: (one) -> null
    catch e
      assert.equal (e instanceof TypeError), true
      assert.equal e.message, 'contextToRoles must accept at least 2 arguments'


  it 'should use the given contextToRoles function', ->

    options = parse
      roleMap: { check: (map, path, method) -> null }
      pathMap: { getToken: (path) -> null }
      contextToRoles: (err, done) -> 'test'

    assert.equal options.contextToRoles(), 'test'
