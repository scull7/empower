
assert    = require 'assert'
Defaults  = require '../../src/defaults'

_validateContext  = (testArr, expectedErr, end) ->
  if not testArr.length then return end()

  Defaults.contextToRoles testArr[0], (err) -> try
    assert.equal err.message, expectedErr
    _validateContext (testArr.slice 1), expectedErr, end
  catch e
    (end e)

describe 'Option Defaults', ->

  describe 'contextToRoles', ->

    it 'should return the roles from "ctx.user.roles" ', (done) ->
      ctx =
        user:
          roles: [ 'test' ]

      Defaults.contextToRoles ctx, (err, roles) ->
        assert.equal err, null
        assert.deepEqual roles, [ 'test' ]
        done()

    it 'should return "context_required" if the context is not set', (done) ->

      testValues  = [
        undefined
        null
        false
        0
      ]
      _validateContext testValues, 'context_required', done


    it 'should return "context_invalid" if the given context is not an object',
    (done) ->

      testValues  = [
        'context'
        1
        true
      ]
      _validateContext testValues, 'context_invalid', done


    it 'should return "context_user_required" if ctx.user is not set', (done) ->

      testValues  = [
        { user: null }
        {}
        { user: undefined }
        { user: 0 }
        { user: false }
      ]
      _validateContext testValues, 'context_user_required', done


    it 'should return "context_user_invalid" if ctx.user is not an object',
    (done) ->

      testValues  = [
        { user: 'user' }
        { user: 1 }
        { user: true }
      ]
      _validateContext testValues, 'context_user_invalid', done


    it 'should return "context_user_roles_required" if ctx.user.roles ' +
    'is not set', (done) ->

      testValues  = [
        { user: roles: null }
        { user: roles: undefined }
        { user: roles: false }
        { user: roles: 0 }
      ]
      _validateContext testValues, 'context_user_roles_required', done


    it 'should return "context_user_roles_invalid" if ctx.user.roles ' +
    'is not an Array', (done) ->

      testValues  = [
        { user: roles: 'roles' }
        { user: roles: 1 }
        { user: roles: true }
        { user: roles: {} }
      ]
      _validateContext testValues, 'context_user_roles_invalid', done
