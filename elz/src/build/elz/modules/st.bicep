param stName string
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param stSku string
param stKind string
param location string

resource st 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: stName
  location: location
  sku: {
    name: stSku
  }
  kind: stKind
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }
}

//resource peSt 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2021-06-01' = {
//  name: 'pe-${stName}'
//  parent: st
//  properties: {}
//}
