targetScope = 'subscription'

@description('Data Share Details')
param dataShares array

module dataShare '../azresources/data-share.bicep' = [for ds in dataShares: {
  name: 'deploy-${ds.accountName}'
  scope: resourceGroup(ds.subscriptionId, ds.rgName)
  params: {
    data_share: ds
  }
}]
