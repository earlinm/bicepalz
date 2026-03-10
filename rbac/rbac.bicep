targetScope = 'managementGroup'

@description('Management Group Id for assignable scope.')
param rbac array

resource roleDefn 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = [ for roles in rbac: {
  name: guid(roles.roleName)
  scope: managementGroup()
  properties: {
    roleName: roles.roleName
    description: roles.roleDescription
    permissions: [
      {
        actions: [
          '*'
        ]
        notActions: [
          'Microsoft.Authorization/*/write'
          'Microsoft.Network/publicIPAddresses/write'
          'Microsoft.Network/virtualNetworks/write'
          'Microsoft.KeyVault/locations/deletedVaults/purge/action'
        ]
        dataActions: []
        notDataActions: []
      }
    ]
    assignableScopes: [
      tenantResourceId('Microsoft.Management/managementGroups', roles.mgid)
    ]
  }
}]
