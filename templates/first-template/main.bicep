@minLength(3)
@maxLength(11)
param storagePrefix string

param storageSKU string = 'Standard_LRS'
param location string = resourceGroup().location

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

resource storageaccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }

  resource service 'fileServices' = {
    name: 'default'
    resource share 'shares' = {
      name: 'exampleshare'
    }
  }
}

