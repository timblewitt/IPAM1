param lawName string

resource law 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: lawName
  location: resourceGroup().location
  properties: {
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}
