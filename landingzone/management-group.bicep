targetScope = 'managementGroup'

param firstLevelMGs array
param secondLevelMGs array
param thirdLevelMGs array

// Create the Root Level MG here - mg-rba
module managementGroups '../azresources/management-groups.bicep' = {
  name: 'deploy_managementGroups'
  params: {
    firstLevelMGs: firstLevelMGs
    secondLevelMGs: secondLevelMGs
    thirdLevelMGs: thirdLevelMGs
  }
}
