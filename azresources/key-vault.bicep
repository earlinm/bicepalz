// scope
targetScope = 'resourceGroup'

// parameters
param location string
// param tenantId string
// param accessPoliciestenantId string
param accessPoliciesprincipalId string
param accessPoliciesSecretsPermissions array
param skuName string

@minLength(3)
@maxLength(24)
param kvName string

// resource definition
resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: kvName
  location: location
  properties: {
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        // tenantId: accessPoliciestenantId
        tenantId: subscription().tenantId
        objectId: accessPoliciesprincipalId
        permissions: {
          secrets: accessPoliciesSecretsPermissions
        }
      }
    ]
    sku: {
      family: 'A'
      name: skuName
    }
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 14
  }

}
output kvUri string = kv.properties.vaultUri
