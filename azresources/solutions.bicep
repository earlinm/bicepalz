targetScope = 'resourceGroup'

@description('Location')
param location string

@description('Log Analytics Workspace Details')
param solutions object

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: solutions.lawName
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2015-10-31' existing = {
  name: solutions.automationAccountName
}

// Link Log Analytics Workspace to Automation Account
resource automationAccountLinkToWorkspace 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: '${workspace.name}/Automation'
  properties: {
    resourceId: automationAccount.id
  }
}

// Add Log Analytics Workspace Solutions
resource workspaceSolutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for ws in solutions.solutionsList: {
  name: '${ws}(${workspace.name})'
  location: location
  properties: {
    workspaceResourceId: workspace.id
  }
  plan: {
    name: '${ws}(${workspace.name})'
    product: 'OMSGallery/${ws}'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  dependsOn: [
    automationAccountLinkToWorkspace
  ]
}]
