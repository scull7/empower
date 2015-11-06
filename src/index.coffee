empower               = require './empower'


Empower = (options) -> empower.bind(null, options)

Empower.PermissionMap = require 'empower-permission'
Empower.RoleMap       = require 'empower-role'


module.exports        = Empower
