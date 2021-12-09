param aspName string
param aspSkuName string
param aspTier string
//param aseId string

resource asp 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: aspName
  location: resourceGroup().location
  sku: {
    name: aspSkuName
    tier: aspTier
  }
//  properties: {
//    hostingEnvironmentProfile: {
//      id: aseId != '' ? aseId : ''
//    }
//  }
}

output aspId string = asp.id
