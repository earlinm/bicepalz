targetScope = 'resourceGroup'

@description('Storage Account Details')
param sa_details object

resource storageaccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: sa_details.name
  location: sa_details.location
  sku: {
    name: sa_details.sku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    isHnsEnabled: sa_details.hnsEnabled
    isSftpEnabled: sa_details.sftpEnabled
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: sa_details.publicNetworkAccess
    supportsHttpsTrafficOnly: true
  }
}
