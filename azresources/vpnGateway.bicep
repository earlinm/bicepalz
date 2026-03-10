targetScope = 'resourceGroup'

@description('Location of resource')
param location string

@description('VPN Gateway details')
param vpnGateway object

@description('Public IP Address')
param pip string

@description('Subnet Id')
param subnetId string

resource vpngateway 'Microsoft.Network/virtualNetworkGateways@2022-01-01' = {
  name: vpnGateway.name
  location: location
  properties: {
    sku: vpnGateway.sku
    gatewayType: vpnGateway.gatewayType
    activeActive: false
    enableBgp: vpnGateway.enableBgp
    vpnType: vpnGateway.vpnType
    ipConfigurations: [
      {
        name: 'vpnGatewayIpConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}
