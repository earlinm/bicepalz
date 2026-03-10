targetScope = 'subscription'

@description('Key Vault Details')
param keyVaults array

// Create Azure Key Vault

module keyVault '../azresources/key-vault.bicep' = [for kv in keyVaults: {
  name: 'deploy-${kv.kvName}'
  scope: resourceGroup(kv.subscriptionId, kv.rgName)
  params: {
    kvName: kv.kvName
    location: kv.location
    skuName: kv.skuName
    accessPoliciesprincipalId: kv.accessPoliciesprincipalId
    accessPoliciesSecretsPermissions: kv.accessPoliciesSecretsPermissions
 }
}]
