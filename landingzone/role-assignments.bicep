targetScope = 'managementGroup'

@description('Roles details')
param roles array

// Role Assignment
module roleAssignment '../azresources/role-assignments.bicep' = [for role in roles: {
  name: 'assign-${role.roleName}-to-${role.name}'
  scope: managementGroup(role.scope)
  params: {
    roleId: role.roleId
    principalId: role.principalId
    principalType: role.principalType
  }
}]
