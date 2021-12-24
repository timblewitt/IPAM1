param logName string
param aaId string

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

resource logAuto 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: '${log.name}/Automation'
  properties: {
    resourceId: aaId
  }
}

output logId string = log.id
