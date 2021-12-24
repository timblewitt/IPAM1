param planName string
param planSkuName string
param planTier string
param aseId string

resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: planName
  location: resourceGroup().location
  sku: {
    name: planSkuName
    tier: planTier
  }
  properties: {
    hostingEnvironmentProfile: {
      id: aseId != '' ? aseId : aseId
    }
  }
}

output planId string = plan.id
