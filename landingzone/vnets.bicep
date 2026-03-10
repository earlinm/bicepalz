targetScope = 'subscription'

@description('Resource Group Details')
param commonValues object

@description('Virtual Network Details')
param vnets array

module rg '../azresources/rg.bicep' = {
  name: 'deploy-${commonValues.rgName}-rg'
  scope: subscription(commonValues.subscriptionId)
  params: {
    rgName: commonValues.rgName
    rgLocation: commonValues.rgLocation
    tags: commonValues.tags
  }
}

module vnet '../azresources/vnet.bicep' = [for vn in vnets:{
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
  name: 'deploy-${vn.vnetName}'
  params: {
    vnet: vn
    location: commonValues.rgLocation
  }
  dependsOn: [
    rg
  ]
}]
