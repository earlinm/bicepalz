targetScope = 'resourceGroup'

@description('General Information about the Organization')
param location string

@description('Log Analytics Workspace Name')
param workspaceName string

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

output lawId string = workspace.id
output lawName string = workspace.name
