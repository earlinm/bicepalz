targetScope = 'resourceGroup'

@description('Virtual Machine Details')
param vm object

@description('Virtual Machine Admin Username')
param adminUsername string

@description('Virtual Machine Admin Password')
@secure()
param adminPassword string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vm.virtualNetworkName
  scope: resourceGroup(vm.subscriptionId, vm.vnetRGname)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: vm.subnetName
  parent: virtualNetwork
}

resource nic 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: vm.nicName
  location: vm.location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}

resource vms 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: vm.vmName
  location: vm.location
  properties: {
    hardwareProfile: {
      vmSize: vm.vmSize
    }
    osProfile: {
      computerName: vm.vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: vm.osVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: vm.saType
        }
      }
      dataDisks: [
        {
          diskSizeGB: 512
          lun: 0
          createOption: 'Empty'
          deleteOption: 'Delete'
          name: vm.dataDiskName
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
