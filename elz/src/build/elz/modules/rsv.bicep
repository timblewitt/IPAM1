param rsvName string
param rsvSku string = 'Standard'
param location string

resource rsv 'Microsoft.RecoveryServices/vaults@2021-08-01' = {
  name: rsvName
  location: location
  sku: {
    name: rsvSku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

output rsvName string = rsv.name
