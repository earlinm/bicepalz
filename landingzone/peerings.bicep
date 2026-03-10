targetScope = 'subscription'

@description('Hub Resource Groups and Network Details')
param peerings array

// Create VNET Peerings
module topeering '../azresources/peering.bicep' = [for vp in peerings: {
  name: 'deploy-${vp.sourceVnetName}-to-${vp.targetVnetName}-peer'
  scope: resourceGroup(vp.sourceVnetRgSubscriptionId, vp.sourceVnetRgName)
  params: {
    targetVnetName: vp.targetVnetName
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    gateTransit: vp.targetGatewayTransit
    sourceVnetName: vp.sourceVnetName
    targetVnetId: '/subscriptions/${vp.targetVnetRgSubscriptionId}/resourceGroups/${vp.targetVnetRgName}/providers/Microsoft.Network/virtualNetworks/${vp.targetVnetName}'
    }
}]

// Create the reverse VNET Peerings
module frompeering '../azresources/peering.bicep' = [for vp in peerings: {
  name: 'deploy-${vp.targetVnetName}-to-${vp.sourceVnetName}-peer'
  scope: resourceGroup(vp.targetVnetRgSubscriptionId, vp.targetVnetRgName)
  params: {
    targetVnetName: vp.sourceVnetName
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    gateTransit: vp.sourceGatewayTransit
    sourceVnetName: vp.targetVnetName
    targetVnetId: '/subscriptions/${vp.sourceVnetRgSubscriptionId}/resourceGroups/${vp.sourceVnetRgName}/providers/Microsoft.Network/virtualNetworks/${vp.sourceVnetName}'
    
  }
}]

