targetScope = 'resourceGroup'

@description('Data Share Details')
param data_share object

resource dataShareAccount 'Microsoft.DataShare/accounts@2021-08-01' = {
  name: data_share.accountName
  location: data_share.location
  identity: {
    type: 'SystemAssigned'
  }
}

resource dataShare 'Microsoft.DataShare/accounts/shares@2021-08-01' = [for share in data_share.shares:{
  name: share.shareName
  parent: dataShareAccount
  properties: {
    description: share.description
    shareKind: share.kind
  }
}]
