targetScope = 'resourceGroup'

@description('Virtual Network Details')
param vnet object

@description('Resource Location')
param location string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnet.vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.vnetAddress
      ]
    }
    enableDdosProtection: vnet.enableDdosProtection
    subnets: vnet.subnets
  }
}
