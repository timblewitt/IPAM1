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
}

resource tableservice 'Microsoft.Storage/storageAccounts/tableServices@2021-04-01' = {
  name: 'default'
  parent: st
}

resource lzim 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-04-01' = {
  name: 'lzim'
  parent: tableservice
}

output stName string = stName
output stId string = st.id
output stApiVersion string = st.apiVersion
