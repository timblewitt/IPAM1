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

resource tableservice 'Microsoft.Storage/storageAccounts/tableServices@2021-04-01' = {
  name: 'default'
  parent: sa
}

resource ipam 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-04-01' = {
  name: 'ipam'
  parent: tableservice
}

output saName string = saName
output saId string = sa.id
output saApiVersion string = sa.apiVersion
