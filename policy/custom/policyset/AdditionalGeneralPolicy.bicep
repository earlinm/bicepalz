targetScope = 'managementGroup'

@description('Policy Name')
param policyName string

@description('Policy Display Name')
param policyDisplayName string

@description('Management Group scope for the policy definition.')
param policyAssignmentManagementGroupId array

@description('MG ID passed from Pipeline')
param mgid string

@description('Allowed Regions')
param allowedRegions array

var policyDefinitionMGScope = tenantResourceId('Microsoft.Management/managementGroups', mgid)

resource additionalPolicySet 'Microsoft.Authorization/policySetDefinitions@2020-03-01' = {
  name: policyName
  properties: {
    displayName: policyDisplayName
    policyDefinitionGroups: [
      {
        name: 'GENERAL'
        displayName: 'Additional Controls'
      }
    ]
    policyDefinitions: [
      {
        groupNames: [
          'GENERAL'
        ]
        policyDefinitionId: extensionResourceId(policyDefinitionMGScope, 'Microsoft.Authorization/policyDefinitions', 'ADD-Allowed-Regions')
        policyDefinitionReferenceId: toLower(replace('Allowed Azure Regions for Resources', ' ', '-'))
        parameters: {
          allowedRegions: {
            value: allowedRegions
          }
        }
      }
    ]
  }
}

