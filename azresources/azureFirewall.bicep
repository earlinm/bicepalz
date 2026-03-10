targetScope = 'resourceGroup'

@description('Location of Firewall')
param location string

@description('PFirewall Name')
param name string

param firewallPolicyId string
param hubIPAddresses object
param ipConfigname string
param publicIpAddress string
param subnetId string
param sku object

resource azureFirewall 'Microsoft.Network/azureFirewalls@2022-01-01' = {
  name: name
  location: location
  properties: {
    firewallPolicy: {
      id: firewallPolicyId
    }
    hubIPAddresses: hubIPAddresses
    ipConfigurations: [
      {
        name: ipConfigname
        properties: {
          publicIPAddress: {
            id: publicIpAddress
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    sku: sku
  }
}

output azureFirewallName string = azureFirewall.name
