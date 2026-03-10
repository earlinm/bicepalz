targetScope = 'managementGroup'

@description('Generic Information')
param location string

@description('Management Group scope for the policy assignment.')
param policyAssignmentManagementGroupId array

@description('Policy set assignment enforcement mode.  Possible values are { Default, DoNotEnforce }.  Default value:  Default')
param enforcementMode string

@description('Policy Name')
param policyDefinitionName string

@description('Display name of Policy')
param policyAssignmentName string

@description('Display name of Policy')
param policyAssignmentDisplayName string

@description('Log Analytics Workspace ID')
param workspaceName string

@description('Log Analytics Workspace Resource group name')
param workspaceRG string

@description('Log Analytics Workspace RG subscription ID')
param workspaceSubscriptionId string

@description('Workspace RG Tags')
param workspaceRGtags object

@description('MG ID passed from Pipeline')
param mgid string

var policyDefinitionId = '/providers/Microsoft.Management/managementGroups/${mgid}/providers/Microsoft.Authorization/policySetDefinitions/${policyDefinitionName}'

// Create LAW Resource group
module rg '../../../azresources/rg.bicep' = {
  name: 'deploy-${workspaceRG}-rg'
  scope: subscription(workspaceSubscriptionId)
  params: {
    rgName: workspaceRG
    rgLocation: location
    tags: workspaceRGtags
  }
}

// Create LAW 
module law '../../../azresources/law.bicep' = {
  name: 'deploy-law-${workspaceName}'
  scope: resourceGroup(workspaceSubscriptionId, workspaceRG)
  params: {
    location: location
    workspaceName: workspaceName
  }
  dependsOn: [
    rg
  ]
}

// Assign Policy
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-03-01' = {
  name: policyAssignmentName
  properties: {
    displayName: policyAssignmentDisplayName
    policyDefinitionId: policyDefinitionId
    notScopes: [
    ]
    parameters: {
      logAnalytics: {
        value: law.outputs.lawId
      }
      logAnalyticsWorkspaceId: {
        value: '/subscriptions/${workspaceSubscriptionId}/resourceGroups/${workspaceRG}/providers/Microsoft.OperationalInsights/workspaces/${law.outputs.lawName}'
      }
    }
    enforcementMode: enforcementMode
  }
  identity: {
    type: 'SystemAssigned'
  }
  location: location
}

// These role assignments are required to allow Policy Assignment to remediate.
resource policySetRoleAssignmentLogAnalyticsContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(mgid, 'loganalytics', 'Log Analytics Contributor')
  scope: managementGroup()
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
    principalId: policyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource policySetRoleAssignmentVirtualMachineContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(mgid, 'loganalytics', 'Virtual Machine Contributor')
  scope: managementGroup()
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
    principalId: policyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource policySetRoleAssignmentMonitoringContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(mgid, 'loganalytics', 'Monitoring Contributor')
  scope: managementGroup()
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
    principalId: policyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
