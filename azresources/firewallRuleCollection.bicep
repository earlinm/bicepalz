targetScope = 'resourceGroup'

@description('Firewall Collection Name')
param name string

resource azureFirewallCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-01-01' = {
  name: name
  properties: {
    priority: 200
    ruleCollections: [
      // Azure AD
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Azure AD'
        priority: 100
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Azure AD Tag'
            destinationAddresses: [
              'AzureActiveDirectory'
            ]
            destinationPorts: [
              '443'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Azure AD FQDNs'
            destinationFqdns: [
              'aadcdn.msauth.net'
              'aadcdn.msftauth.net'
            ]
            destinationPorts: [
              '443'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
        ]
      }
      // Azure Resource Manager
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Azure Resource Manager'
        priority: 105
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Azure Resource Manager Tag'
            destinationAddresses: [
              'AzureResourceManager'
            ]
            destinationPorts: [
              '443'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
        ]
      }
      // Azure Portal
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Azure Portal'
        priority: 110
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Azure Portal Tag'
            destinationAddresses: [
              'AzurePortal'
            ]
            destinationPorts: [
              '443'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Azure Portal FQDNs'
            destinationFqdns: [
              'afd.hosting.portal.azure.net'
            ]
            destinationPorts: [
              '443'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
        ]
      }
      // Azure Monitor
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Azure Monitor'
        priority: 120
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Azure Monitor Tag'
            destinationAddresses: [
              'AzureMonitor'
            ]
            destinationPorts: [
              '443'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
        ]
      }
      // Azure Automation & Guest Configuration
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Azure Automation and Guest Configuration'
        action: {
          type: 'Allow'
        }
        priority: 130
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'GuestAndHybridManagement Tag'
            destinationAddresses: [
              'GuestAndHybridManagement'
            ]
            destinationPorts: [
              '443'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Guest Configuration - FQDNs'
            destinationFqdns: [
              'agentserviceapi.guestconfiguration.azure.com'
            ]
            destinationPorts: [
              '443'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'TCP'
            ]
          }
        ]
      }
      // Azure Synapse Analytics Application Rules
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Synapse Analytics FQDNs'
        action: {
          type: 'Allow'
        }
        priority: 997
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'Synapse Analytics FQDNs'
            targetFqdns: [
              'web.azuresynapse.net'
              '*.dev.azuresynapse.net'
              '*.sql.azuresynapse.net'
            ]
            sourceAddresses: [
              '*'
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
          }
        ]
      }
      // Azure Backup
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Azure Backup'
        action: {
          type: 'Allow'
        }
        priority: 1100
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'Azure Backup'
            fqdnTags: [
              'AzureBackup'
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            sourceAddresses: [
              '*'
            ]
          }
        ]
      }
    ]
  }
}

output azureFirewallRuleCollectionId string = azureFirewallCollectionGroup.id
