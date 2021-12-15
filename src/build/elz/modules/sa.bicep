param saName string
param saSku string
param saKind string

resource sa 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: saName
  location: resourceGroup().location
  sku: {
    name: saSku
  }
  kind: saKind
}

