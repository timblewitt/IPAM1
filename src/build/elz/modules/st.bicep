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

resource st 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: stName
  location: resourceGroup().location
  sku: {
    name: stSku
  }
  kind: stKind
}

