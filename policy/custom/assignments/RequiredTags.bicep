targetScope = 'managementGroup'

@description('Location of Policy Assignments')
param location string

@description('Management Group scope for the policy assignment.')
param policyAssignmentManagementGroupId array

@description('MG ID passed from Pipeline')
param mgid string

@description('Policy set assignment enforcement mode.  Possible values are { Default, DoNotEnforce }.  Default value:  Default')
param enforcementMode string

@description('Policy Name')
param policyDefinitionName string

@description('Display name of Policy')
param policyAssignmentName string

@description('Display name of Policy')
param policyAssignmentDisplayName string

@description('Non Compliant Messages for Policy')
param regionNonCompliantMessage string
param environmentNonCompliantMessage string
param resourcetypeNonCompliantMessage string
param managedbyNonCompliantMessage string


var policyDefinitionId = '/providers/Microsoft.Management/managementGroups/${mgid}/providers/Microsoft.Authorization/policySetDefinitions/${policyDefinitionName}'

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyAssignmentName
  properties: {
    displayName: policyAssignmentDisplayName
    policyDefinitionId: policyDefinitionId
    notScopes: [

    ]
    parameters: {
    }
    enforcementMode: enforcementMode
    nonComplianceMessages: [
      {
        message: regionNonCompliantMessage
        policyDefinitionReferenceId: toLower(replace('Require Region tag on resource group', ' ', '-'))
      }
      {
        message: environmentNonCompliantMessage
        policyDefinitionReferenceId: toLower(replace('Require environment tag on resource group', ' ', '-'))
      }
      {
        message: resourcetypeNonCompliantMessage
        policyDefinitionReferenceId: toLower(replace('Require ResourceType tag on resource group', ' ', '-'))
      }
      {
        message: managedbyNonCompliantMessage
        policyDefinitionReferenceId: toLower(replace('Require ManagedBy tag on resource group', ' ', '-'))
      }
      
    ]
  }
  identity: {
    type: 'SystemAssigned'
  }
  location: location
}
