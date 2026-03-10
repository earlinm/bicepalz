targetScope = 'subscription'

@description('Location of resource')
param commonValues object

@description('VPN Gateway details')
param vpnGateway object

module vpnGatewayPublicIp '../azresources/publicIp.bicep' = {
  name: 'deploy-${vpnGateway.publicIp.name}'
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
  params: {
    name: vpnGateway.publicIp.name
    location: commonValues.rgLocation
    sku: vpnGateway.publicIp.sku
    properties: vpnGateway.publicIp.properties
  }
}

resource existingSubnetId 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: vpnGateway.vnetName
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
}

module vpnGateways '../azresources/vpnGateway.bicep' = {
  name: 'deploy-${vpnGateway.name}'
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
  params: {
    location: commonValues.rgLocation
    vpnGateway: vpnGateway
    pip: vpnGatewayPublicIp.outputs.publicIpId
    subnetId: '${existingSubnetId.id}/subnets/GatewaySubnet'
  }
  dependsOn: [
    vpnGatewayPublicIp
    existingSubnetId
  ]
}
