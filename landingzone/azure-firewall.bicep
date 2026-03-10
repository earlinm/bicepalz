targetScope = 'subscription'

@description('Location for the deployment.')
param commonValues object

@description('Azure Firewall Policy Name')
param firewall object

module azureFirewallPublicIp '../azresources/publicIp.bicep' = {
  name: 'deploy-${firewall.publicIp.name}'
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
  params: {
    name: firewall.publicIp.name
    location: commonValues.rgLocation
    sku: firewall.publicIp.sku
    properties: firewall.publicIp.properties
  }
}

module azureFirewallPolicy '../azresources/azureFirewallPolicy.bicep' = {
  name: 'deploy-${firewall.policy.name}'
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
  params: {
    name: firewall.policy.name
    location: commonValues.rgLocation
    properties: firewall.policy.properties
  }
}

module azureFirewall '../azresources/azureFirewall.bicep' = {
  name: 'deploy-${firewall.firewall.name}'
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
  params: {
    location: commonValues.rgLocation
    name: firewall.firewall.name
    firewallPolicyId: azureFirewallPolicy.outputs.firewallpolicyId
    hubIPAddresses: firewall.firewall.hubIPAddresses
    ipConfigname: firewall.firewall.ipConfigname
    publicIpAddress: azureFirewallPublicIp.outputs.publicIpId
    subnetId: firewall.firewall.subnetId
    sku: firewall.firewall.sku
  }
  dependsOn: [
    azureFirewallPolicy
    azureFirewallPublicIp
  ]
}

module azureFirewallCollection '../azresources/firewallRuleCollection.bicep' = {
  name: 'deploy-firewall-rulecollection'
  scope: resourceGroup(commonValues.subscriptionId, commonValues.rgName)
  params: {
    name: '${azureFirewallPolicy.outputs.firewallpolicyname}/${firewall.firewall.collectionName}'
  }
  dependsOn: [
    azureFirewall
    azureFirewallPolicy
  ]
}
