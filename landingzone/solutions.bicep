targetScope = 'subscription'

@description('Location')
param location string

@description('Log Analytics Workspace Details')
param automationSolutions array

module automationAccounts '../azresources/automation-accounts.bicep' = [for aa in automationSolutions: {
  name: 'deploy-automation-account'
  scope: resourceGroup(aa.subscriptionId, aa.rgName)
  params: {
    location: location
    automationAccounts: aa
  }
}]

module solutions '../azresources/solutions.bicep' = [for as in automationSolutions:{
  name: 'deploy-solutions'
  scope: resourceGroup(as.subscriptionId, as.rgName)
  params: {
    location: location
    solutions: as
  }
  dependsOn: [
    automationAccounts
  ]
}]
