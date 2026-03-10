
targetScope = 'managementGroup'

@description('Management Group scope for the policy definition.')
param policyAssignmentManagementGroupId array

@description('MG ID passed from Pipeline')
param mgid string

@description('Required set of tags that is inherited from resource Group.')
param inheritTags array

// Set the Scope
var policyDefinitionMGScope = tenantResourceId('Microsoft.Management/managementGroups', mgid)

// Retrieve the templated azure policies as json object
var tagsInheritedFromResourceGroupPolicyTemplate = json(loadTextContent('../../../config/policy/custom/definitions/policyset/templates/Inherit-Tag-From-ResourceGroup/azurepolicy.json'))

// Inherit tags from resource group to resources
resource tagsInheritedFromResourceGroupPolicy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = [for tag in inheritTags: {
  name: '${tagsInheritedFromResourceGroupPolicyTemplate.name}-${tag}'
  properties: {
    metadata: {
      tag: tag
    }
    displayName: '${tagsInheritedFromResourceGroupPolicyTemplate.properties.displayName}: ${tag}'
    mode: tagsInheritedFromResourceGroupPolicyTemplate.properties.mode
    policyRule: tagsInheritedFromResourceGroupPolicyTemplate.properties.policyRule
    parameters: tagsInheritedFromResourceGroupPolicyTemplate.properties.parameters
  }
}]

resource tagsInheritedFromResourceGroupPolicySet 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: tagsInheritedFromResourceGroupPolicyTemplate.name
  properties: {
    displayName: tagsInheritedFromResourceGroupPolicyTemplate.properties.displayName
    policyDefinitions: [for (tag, i) in inheritTags: {
      policyDefinitionId: extensionResourceId(policyDefinitionMGScope, 'Microsoft.Authorization/policyDefinitions', tagsInheritedFromResourceGroupPolicy[i].name)
      policyDefinitionReferenceId: toLower(replace('Inherit ${tag} tag from the resource group if missing', ' ', '-'))
      parameters: {
        tagName: {
          value: tag
        }
      }
    }]
  }
}
