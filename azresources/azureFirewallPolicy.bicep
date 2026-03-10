targetScope = 'resourceGroup'

@description('Location of Firewall Policy')
param location string

@description('Name of Firewall Policy')
param name string

@description('Properties of Firewall Policy')
param properties object

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-08-01' = {
  name: name
  location: location
  properties: properties
}

output firewallpolicyId string = firewallPolicy.id
output firewallpolicyname string = firewallPolicy.name
