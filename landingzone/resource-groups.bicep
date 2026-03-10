targetScope = 'subscription'

@description('Resource Group Details')
param resourceGroups array

module rg '../azresources/rg.bicep' = [for rg in resourceGroups: {
  name: 'deploy-${rg.name}-rg'
  scope: subscription(rg.subscriptionId)
  params: {
    rgName: rg.name
    rgLocation: rg.rgLocation
    tags: rg.tags
  }
}]
