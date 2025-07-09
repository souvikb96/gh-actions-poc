

@description('The name of the function app that you wish to create.')
param FunctionAppName string

@description('Storage Account type.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param StorageAccountType string

@description('Storage Account Name.')
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

@description('Container for Program Logs.')
param AppLogContainerName string

@description('File for Program Logs.')
param AppLogFileName string

@description('ID of Tenant.')
param TenantID string

@description('Azure Subscription ID.')
param SubscriptionId string


module StorageAccount 'modules/cc_storage_deploy.bicep' = {
  name: 'StorageAccount'
  params: {
    Location: Location
    StorageAccountName: StorageAccountName
    StorageAccountType: StorageAccountType
    AppLogContainerName: AppLogContainerName
  }
}


module FunctionApp 'modules/cc_backend_deploy.bicep' = {
  name: 'FunctionApp'
  params: {
    Location: Location
    StorageAccountName: StorageAccountName
    StorageAccountType: StorageAccountType
    AppLogContainerName: AppLogContainerName
    AppLogFileName: AppLogFileName
    FunctionAppName: FunctionAppName
    Runtime: Runtime
    SA_Connection: StorageAccount.outputs.sa_connection
  }
}

/*
module qTest_To_DB 'modules/aqua_qTest_to_db_deploy.bicep' = {
  name: 'qTest_To_DB'
  params: {
    location: location
    StorageAccountName: StorageAccountName
    StorageAccountType: StorageAccountType
    AppLogContainerName: AppLogContainerName
    AppLogFileName: AppLogFileName
    qTest_To_DB_AppName: qTest_To_DB_AppName
    appInsightsLocation: appInsightsLocation
    runtime: runtime
    sa_connection: StorageAccount.outputs.sa_connection
  }
}

module qTest_To_DB_API 'modules/aqua_qTest_to_db_api_deploy.bicep' = {
  name: 'qTest_To_DB_API'
  params: {
    location: location
    StorageAccountName: StorageAccountName
    StorageAccountType: StorageAccountType
    APILogContainerName: APILogContainerName
    APILogFileName: APILogFileName
    qTest_To_DB_API_AppName: qTest_To_DB_API_AppName
    appInsightsLocation: appInsightsLocation
    runtime: runtime
    sa_connection: StorageAccount.outputs.sa_connection
  }
}

module Database 'modules/aqua_database_deploy.bicep' = {
  name: 'Database'
  params: {
    location: location
    DatabaseServerName: DatabaseServerName
    DatabaseName: DatabaseName
    sid: sid
    TenantID: TenantID
    admin: admin
    subscriptionId: subscriptionId
  }
}
*/

