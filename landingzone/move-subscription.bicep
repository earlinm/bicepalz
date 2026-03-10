targetScope = 'managementGroup'

@description('Subscription Details')
param subs array

module movesub '../azresources/move-subscription.bicep' = [for sub in subs: {
  name: 'move-${sub.subscriptionName}-to-${sub.targetMGid}'
  scope: managementGroup(sub.targetMGid)
  params: {
    mgId: sub.targetMGid
    subId: sub.subscriptionId
  }
}]
