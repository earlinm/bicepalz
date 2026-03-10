targetScope = 'managementGroup'

param firstLevelMGs array
param secondLevelMGs array
param thirdLevelMGs array

// Create the Root MG here - mg-rogersbank
@batchSize(1)
resource firstLevelMG 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in firstLevelMGs: {
  name: mg.id
  scope: tenant()
  properties: {
    displayName: mg.displayName
    details: {
      parent: {
        id: '/providers/Microsoft.Management/managementGroups/${mg.parentId}'
      }
    }
  }
}]

// Create the Parent MG here - mg-landingzone
@batchSize(1)
resource secondLevelMG 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in secondLevelMGs: {
  name: mg.id
  scope: tenant()
  properties: {
    displayName: mg.displayName
    details: {
      parent: {
        id: '/providers/Microsoft.Management/managementGroups/${mg.parentId}'
      }
    }
  }
  dependsOn: firstLevelMG
}]

// Create the Child MG here - mg-lz-dev
@batchSize(1)
resource thirdLevelMG 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in thirdLevelMGs: {
  name: mg.id
  scope: tenant()
  properties: {
    displayName: mg.displayName
    details: {
      parent: {
        id: '/providers/Microsoft.Management/managementGroups/${mg.parentId}'
      }
    }
  }
  dependsOn: secondLevelMG
}]
