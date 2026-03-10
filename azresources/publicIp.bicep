targetScope = 'resourceGroup'

@description('Location of Public IP')
param location string

@description('SKU of Public IP')
param sku object

@description('Properties of Public IP')
param properties object

@description('Public Ip Name')
param name string

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: name
  location: location
  sku: sku
  properties: properties
}

output publicIpId string = publicIp.id
