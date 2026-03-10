targetScope = 'subscription'

@description('Resource Group Name')
param rgName string

@description('Resource Group Location')
param rgLocation string

@description('Resource Group Tags')
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgLocation
  tags: tags
}
