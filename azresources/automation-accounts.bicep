targetScope = 'resourceGroup'

@description('General Information about the Organization')
param location string

@description('Log Analytics Workspace Details')
param automationAccounts object

// Create Automation Account
resource automationAccount 'Microsoft.Automation/automationAccounts@2015-10-31' = {
  name: automationAccounts.automationAccountName
  location: location
  properties: {
    sku: {
      name: automationAccounts.sku
    }
  }
}
