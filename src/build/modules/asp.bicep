param aspName string
param aspSku string
param aspTier string

resource asp 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: aspName
  location: resourceGroup().location
  sku: {
    name: aspSku
    tier: aspTier
  }
}

output aspId string = asp.id
