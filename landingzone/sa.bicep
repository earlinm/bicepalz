targetScope = 'subscription'

@description('Storage Account Details Array')
param storageAccounts array

module azurestorageaccount '../azresources/storage_accounts.bicep' = [for sa in storageAccounts: {
  name: 'deploy-sa-${sa.name}'
  scope: resourceGroup(sa.subscriptionId, sa.rgName)
  params: {
    sa_details: sa
  }
}]
