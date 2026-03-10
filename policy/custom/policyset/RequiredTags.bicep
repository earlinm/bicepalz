
targetScope = 'managementGroup'

@description('Management Group scope for the policy definition.')
param policyAssignmentManagementGroupId array

@description('MG ID passed from Pipeline')
param mgid string

@description('Required set of tags that must exist on resource groups and resources.')
param requiredTags array

// Set the Scope
var policyDefinitionMGScope = tenantResourceId('Microsoft.Management/managementGroups', mgid)

// Retrieve the templated azure policies as json object
var tagsRequiredOnResourceGroupPolicyTemplate = json(loadTextContent('../../../config/policy/custom/definitions/policyset/templates/ResourceGroup-Require-Tags/azurepolicy.json'))

// Required tags on resource groups
resource requiredRGTagsPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = [for tag in requiredTags: {
  name: '${tagsRequiredOnResourceGroupPolicyTemplate.name}-${tag}'
  properties: {
    metadata: {
      tag: tag
    }
    displayName: '${tagsRequiredOnResourceGroupPolicyTemplate.properties.displayName}: ${tag}'
    mode: tagsRequiredOnResourceGroupPolicyTemplate.properties.mode
    policyRule: tagsRequiredOnResourceGroupPolicyTemplate.properties.policyRule
    parameters: tagsRequiredOnResourceGroupPolicyTemplate.properties.parameters
  }
}]

resource requiredRGTagsPolicySet 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: tagsRequiredOnResourceGroupPolicyTemplate.name
  properties: {
    displayName: tagsRequiredOnResourceGroupPolicyTemplate.properties.displayName
    policyDefinitions: [for (tag, i) in requiredTags: {
      policyDefinitionId: extensionResourceId(policyDefinitionMGScope, 'Microsoft.Authorization/policyDefinitions', requiredRGTagsPolicyDefinition[i].name)
      policyDefinitionReferenceId: toLower(replace('Require ${tag} tag on resource group', ' ', '-'))
      parameters: {
        tagName: {
          value: tag
        }
      }
    }]
  }
  dependsOn: [
    requiredRGTagsPolicyDefinition
  ]
}
