

param FunctionAppName string

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

@description('The language worker runtime to load in the function app.')
@allowed([
  'node'
  'dotnet'
  'java'
])
param Runtime string

@description('Container for DB Logs.')
param AppLogContainerName string

@description('File for DB Logs.')
param AppLogFileName string

@description('sa_connection.')
param SA_Connection string

resource StorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: StorageAccountName
  location: Location
  sku: {
    name: StorageAccountType
  }
}

resource HostingPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: FunctionAppName
  location: Location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

/*
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: Backend_AppName
  location: appInsightsLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}
*/

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: FunctionAppName
  location: Location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: HostingPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: SA_Connection
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: SA_Connection
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(FunctionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~20'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: Runtime
        }
        {
          name: 'AZURE_STORAGE_CONNECTION_STRING'
          value: SA_Connection
        }
        {
          name: 'BLOB_NAME'
          value: AppLogFileName
        }
        {
          name: 'LOG_CONTAINER_NAME'
          value: AppLogContainerName
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}



