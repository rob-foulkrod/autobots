@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'
param location string = resourceGroup().location
param appServicePlanName string = 'exampleplan'

@description('Base name of the resource such as web app name and app service plan ')
@minLength(2)
param webAppName string

@description('The Runtime stack of current web app')
param linuxFxVersion string = 'php|7.0'
param resourceTags object = {
  Environment: 'Dev'
  Project: 'Tutorial'
}

var uniqueStorageName_var = concat(storagePrefix, uniqueString(resourceGroup().id))
var webAppPortalName_var = concat(webAppName, uniqueString(resourceGroup().id))

resource uniqueStorageName 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: uniqueStorageName_var
  location: location
  tags: resourceTags
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource webAppPortalName 'Microsoft.Web/sites@2021-03-01' = {
  name: webAppPortalName_var
  location: location
  tags: resourceTags
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanName_resource.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource appServicePlanName_resource 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags
  sku: {
    name: 'B1'
    size: 'B1'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    name: 'farm'
    perSiteScaling: false
    reserved: true
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

output storageEndpoint object = uniqueStorageName.properties.primaryEndpoints
output webappName string = webAppPortalName.properties.name