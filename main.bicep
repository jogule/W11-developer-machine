param name string = 'W11'
param location string = resourceGroup().location

@allowed([
  'Standard_D2s_v3'
  'Standard_D4s_v3'
])
param vmSize string = 'Standard_D2s_v3'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: '${name}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: '${name}-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: '${name}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'nsgRule'
        properties: {
          description: 'AllowRDPInbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}


resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
          publicIPAddress: {           
            id: publicIPAddress.id
          }
        }
      }
    ]
  }
}

resource disk 'Microsoft.Compute/disks@2021-08-01' = {
  name: '${name}_OsDisk_1'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Import'     
      sourceUri: 'https://jonguzxyz.blob.core.windows.net/vhds/W11VM.vhd'
    }
    osType: 'Windows'
    hyperVGeneration: 'V2'
  }
}

resource diags 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'stw11diags${substring(guid(deployment().name, subscription().id),0,3)}'
  location: location
  kind: 'Storage'
  sku: {
    name: 'Standard_LRS'
  }
}


resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        caching: 'ReadWrite'
        createOption: 'Attach'
        managedDisk: {
          id: disk.id
          storageAccountType: 'Premium_LRS'
        }
        osType: 'Windows'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    licenseType: 'Windows_Client'
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'https://${diags.name}.blob.core.windows.net/'
      }
    }
  }
}

output user string = 'demouser'
output passwd string = 'Cundinamarc@123!'
