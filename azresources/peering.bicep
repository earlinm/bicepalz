targetScope = 'resourceGroup'

@description('Source Virtual Network Name.')
param sourceVnetName string

@description('Target Virtual Network Resource Id.')
param targetVnetId string

@description('Virtual Network Peering Name.')
param targetVnetName string

@description('Boolean flag to determine virtual network access through the peer.  Default: true')
param allowVirtualNetworkAccess bool 

@description('Boolean flag to determine traffic forwarding.  Default: true')
param allowForwardedTraffic bool 

@description('Boolean flag to determine whether remote gateways are used.  Default: false')
param useRemoteGateways bool 

@description('Boolean flag to determine whether remote gateways are used.  Default: false')
param gateTransit bool

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: '${sourceVnetName}/${targetVnetName}'
  properties: {
    useRemoteGateways: useRemoteGateways
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: gateTransit
    remoteVirtualNetwork: {
      id: targetVnetId
    }
  }
}
