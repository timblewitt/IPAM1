param planName string
param planSkuName string
param planTier string
param location string

resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: planName
  location: location
  sku: {
    name: planSkuName
    tier: planTier
  }
}

output planId string = plan.id
