targetScope = 'managementGroup'

@description('Target MG id.')
param mgId string

@description('Subscription to be moved.')
param subId string

resource move 'Microsoft.Management/managementGroups/subscriptions@2020-05-01' = {
  name: '${mgId}/${subId}'
  scope: tenant()
}
