param faName string
param faplanId string
param faStName string
param faStId string
param faStApiVersion string
param logId string
param location string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: faName
  location: location
  kind: 'web'
  properties: { 
    Application_Type: 'web'
    RetentionInDays: 30
    WorkspaceResourceId: logId
  }
}

resource fa 'Microsoft.Web/sites@2021-02-01' = {
  name: faName
  kind: 'functionapp'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: faplanId
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
            name: 'FUNCTIONS_WORKER_RUNTIME'
            value: 'powershell'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${faStName};AccountKey=${listKeys('${faStId}', '${faStApiVersion}').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${faStName};AccountKey=${listKeys('${faStId}', '${faStApiVersion}').keys[0].value};EndpointSuffix=core.windows.net'
        }
      ]
      use32BitWorkerProcess: false
      ftpsState: 'Disabled'
    }
  }
}
