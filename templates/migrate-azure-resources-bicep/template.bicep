@description('Location for resources.')
param location string = resourceGroup().location

@allowed([
  'prod'
  'dev'
  'test'
])
@description('The list of allowed environment names.')
param environment string = 'prod'

param virtualNetworks_ToyTruck_vnet_name string = 'ToyTruck-vnet'
param virtualMachines_ToyTruckServer_aa_name string = 'ToyTruckServer-aa'
param networkInterfaces_toytruckserver_aa284_name string = 'toytruckserver-aa284'
param publicIPAddresses_ToyTruckServer_aa_ip_name string = 'ToyTruckServer-aa-ip'
param networkSecurityGroups_ToyTruckServer_aa_nsg_name string = 'ToyTruckServer-aa-nsg'

resource publicIPAddresses_ToyTruckServer_aa_ip_name_resource 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIPAddresses_ToyTruckServer_aa_ip_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.228.67.16'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualMachines_ToyTruckServer_aa_name_resource 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: virtualMachines_ToyTruckServer_aa_name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_ToyTruckServer_aa_name}_disk1_f9f51163d1604c7d8057e9895a078755'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_ToyTruckServer_aa_name}_disk1_f9f51163d1604c7d8057e9895a078755')
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_ToyTruckServer_aa_name
      adminUsername: 'yshapkin'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_toytruckserver_aa284_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource networkSecurityGroups_ToyTruckServer_aa_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: networkSecurityGroups_ToyTruckServer_aa_nsg_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        id: networkSecurityGroups_ToyTruckServer_aa_nsg_name_SSH.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_ToyTruckServer_aa_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2022-01-01' = {
  name: '${networkSecurityGroups_ToyTruckServer_aa_nsg_name}/SSH'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_ToyTruckServer_aa_nsg_name_resource
  ]
}

resource virtualNetworks_ToyTruck_vnet_name_resource 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworks_ToyTruck_vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_ToyTruck_vnet_name_default.id
        properties: {
          addressPrefix: '10.1.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_ToyTruck_vnet_name_default 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: '${virtualNetworks_ToyTruck_vnet_name}/default'
  properties: {
    addressPrefix: '10.1.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_ToyTruck_vnet_name_resource
  ]
}

resource networkInterfaces_toytruckserver_aa284_name_resource 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: networkInterfaces_toytruckserver_aa284_name
  location: location
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_toytruckserver_aa284_name_resource.id}/ipConfigurations/ipconfig1'
        etag: 'W/"c2323592-0b0b-4c3d-bc6a-a46e9c0aaa70"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.1.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            name: 'ToyTruckServer-aa-ip'
            id: publicIPAddresses_ToyTruckServer_aa_ip_name_resource.id
            properties: {
              provisioningState: 'Succeeded'
              resourceGuid: '4d366b14-c103-4cdd-9b20-87e4f02acbd4'
              publicIPAddressVersion: 'IPv4'
              publicIPAllocationMethod: 'Dynamic'
              idleTimeoutInMinutes: 4
              ipTags: []
              ipConfiguration: {
                id: '${networkInterfaces_toytruckserver_aa284_name_resource.id}/ipConfigurations/ipconfig1'
              }
              deleteOption: 'Detach'
            }
            type: 'Microsoft.Network/publicIPAddresses'
            sku: {
              name: 'Basic'
              tier: 'Regional'
            }
          }
          subnet: {
            id: virtualNetworks_ToyTruck_vnet_name_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    networkSecurityGroup: {
      id: networkSecurityGroups_ToyTruckServer_aa_nsg_name_resource.id
    }
    nicType: 'Standard'
  }
}
