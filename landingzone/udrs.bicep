targetScope = 'subscription'

@description('General Information about the Organization')
param commonValues object

@description('UDR route details')
param udrs array

module routes '../azresources/udr.bicep' = [for udr in udrs: {
  name: 'deploy-${udr.udrName}'
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
  params: {
    location: commonValues.rgLocation
    udrroutes: udr
  }
}]
