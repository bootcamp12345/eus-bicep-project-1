param location string
param appServiceAppName string

@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param environmentName string

var appServicePlanName = 'toy-product-launch-plan-${environmentName}'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      localMySqlEnabled: false
      netFrameworkVersion: 'v4.6'
    }
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
