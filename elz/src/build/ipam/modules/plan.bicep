param planName string
param planSkuName string
param planTier string
param aseId string
param location string

resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: planName
  location: location
  sku: {
    name: planSkuName
    tier: planTier
  }
  properties: aseId != '' ? { 
    hostingEnvironmentProfile: {
      id: aseId
    }
  } : {}
}

output planId string = plan.id

