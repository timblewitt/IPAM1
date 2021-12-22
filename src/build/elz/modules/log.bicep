param logName string

resource log 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logName
  location: resourceGroup().location
  properties: {
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}
