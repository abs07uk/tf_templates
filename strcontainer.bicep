@description('Specifies the location for resources.')
param location string = 'uksouth'

resource str2 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'uksamr01str02'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
 }

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: str2
}

resource container1 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'tfstate'
  parent: blobService
  properties: {
  
    publicAccess: 'Container'
  }
}
