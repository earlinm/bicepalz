targetScope = 'resourceGroup'

@description('Synapse Details')
param synapse_details object

@description('SQL Username')
param sqlusername string

@description('Optional. AAD object ID of initial workspace admin.')
param initialWorkspaceAdminObjectID string = ''

@secure()
@description('SQL Password')
param sqlpassword string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: synapse_details.saName
}

resource aadUser 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'az-sg-rb-synadmin'
}

resource storageAccountBlobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: synapse_details.blobRetentionDays
    }
  }
}

resource storageAccountBlob 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: synapse_details.blobName
  parent: storageAccountBlobServices
  properties: {
    publicAccess: 'None'
  }
}

resource synapsePrivateLinkHubs 'Microsoft.Synapse/privateLinkHubs@2021-06-01' = {
  name: synapse_details.plhName
  location: synapse_details.location
}

resource synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapse_details.workspaceName
  tags: synapse_details.tags
  location: synapse_details.location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    cspWorkspaceAdminProperties: !empty(initialWorkspaceAdminObjectID) ? {
      initialWorkspaceAdminObjectId: initialWorkspaceAdminObjectID
    } : null
    defaultDataLakeStorage: {
      accountUrl: 'https://${storageAccount.name}.dfs.core.windows.net'
      createManagedPrivateEndpoint: true
      filesystem: storageAccountBlob.name
      resourceId: storageAccount.id
    }
    managedResourceGroupName: synapse_details.managedRGName
    publicNetworkAccess: 'Enabled'
    managedVirtualNetwork: 'default'
    sqlAdministratorLogin: sqlusername
    sqlAdministratorLoginPassword: sqlpassword
  }
}

resource synapseSQLPool 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  name: synapse_details.sqlPoolName
  tags: synapse_details.tags
  location: synapse_details.location
  sku: {
    name: synapse_details.sqlPoolSKUname
  }
  parent: synapseWorkspace
  properties: {
    collation: 'SQL_LATIN1_GENERAL_CP1_CI_AS'
    createMode: 'Default'
  }
}

// resource synapseAADauth 'Microsoft.Synapse/workspaces/administrators@2021-06-01' = {
//   name: synapse_details.aadAuthName
//   parent: synapseWorkspace
//   properties: {
//     // administratorType: synapse_details.aadAuthType
//     login: synapse_details.aadAuthName
//     sid: synapse_details.aadAuthSID
//     tenantId: synapse_details.aadAuthTenantId
//   }
//   dependsOn: [
//     synapseSQLPool
//   ]
// }
