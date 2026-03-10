targetScope = 'resourceGroup'

@description('General Information about the Organization')
param location string

@description('User Defined Routes')
param udrroutes object

// Create the UDR - VirtualApplicances
resource udr 'Microsoft.Network/routeTables@2020-11-01' = {
  name: udrroutes.udrName
  location: location
  properties: {
    disableBgpRoutePropagation: udrroutes.disableBgpRoutePropagation
    routes: udrroutes.routes
  }
}
