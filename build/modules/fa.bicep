param faName string
param faAspId string
param faSaName string
param faSaId string
param faSaApiVersion string
param lawId string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: faName
  location: resourceGroup().location
  kind: 'web'
  properties: { 
    Application_Type: 'web'
    RetentionInDays: 30
    WorkspaceResourceId: lawId
  }
}

resource fa 'Microsoft.Web/sites@2021-02-01' = {
  name: faName
  kind: 'functionapp'
  location: resourceGroup().location
  properties: {
    serverFarmId: faAspId
    siteConfig: {
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': appInsights.properties.InstrumentationKey
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
          value: 'DefaultEndpointsProtocol=https;AccountName=${faSaName};AccountKey=${listKeys('${faSaId}', '${faSaApiVersion}').keys[0].value};EndpointSuffix=core.windows.net'
        }
//        {
//          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
//          value: 'DefaultEndpointsProtocol=https;AccountName=${faSaName};AccountKey=${listKeys('${faSaId}', '${faSaApiVersion}').keys[0].value};EndpointSuffix=core.windows.net'
//        }
      ]
      use32BitWorkerProcess: false
      ftpsState: 'Disabled'
    }
  }
}
