@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param StorageAccountType string

@description('Storage Account Name')
param StorageAccountName string

@description('Location for all resources.')
param Location string

@description('Container for Program Logs.')
param AppLogContainerName string

resource StorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: StorageAccountName
  location: Location
  sku: {
    name: StorageAccountType
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    defaultToOAuthAuthentication: true
  }
}

resource BlobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: '${StorageAccount.name}/default'
  properties: {
    deleteRetentionPolicy: {
      allowPermanentDelete: true
      days: 1
      enabled: true
    }
  }
}

resource AppLogContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  parent: BlobService
  name: AppLogContainerName
  properties: {
    publicAccess: 'Blob'
    metadata: {}
  }
}

output sa_connection string = 'DefaultEndpointsProtocol=https;AccountName=${StorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${StorageAccount.listKeys().keys[0].value}'


