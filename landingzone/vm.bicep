targetScope = 'subscription'

@description('Virtual Machine Details')
param virtualMachines array

@description('Virtual Machine Admin Username')
param adminUsername string

@description('Virtual Machine Admin Password')
@secure()
param adminPassword string

module virtualMachine '../azresources/virtual-machine.bicep' = [for vm in virtualMachines: {
  name: 'deploy-${vm.vmName}'
  scope: resourceGroup(vm.subscriptionId, vm.rgName)
  params: {
    vm: vm
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}]
