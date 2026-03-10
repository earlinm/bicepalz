targetScope = 'subscription'

@description('Synapse Workspace Array')
param synapseSQL array

@description('SQL Username')
param sqlusername string

@secure()
@description('SQL Password')
param sqlpassword string

module synapse '../azresources/synapse.bicep' = [for sql in synapseSQL: {
  name: 'deploy-${sql.workspaceName}'
  scope: resourceGroup(sql.subscriptionId, sql.rgName)
  params: {
    synapse_details: sql
    sqlusername: sqlusername
    sqlpassword: sqlpassword
  }
}]
