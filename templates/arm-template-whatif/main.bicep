@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

param tags object = {
  CostCenter: '12345'
}

resource vnet 'Microsoft.Network/virtualNetworks@2018-10-01' = {
  name: 'vnet-001'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/15'
      ]
    }
    enableVmProtection: false
    enableDdosProtection: false
    subnets: [
      {
        name: 'subnet002'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
