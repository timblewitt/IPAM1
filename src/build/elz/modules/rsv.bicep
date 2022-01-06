param rsvName string
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param rsvStorageType string = 'LocallyRedundant'
param rsvSku string = 'Standard'

resource rsv 'Microsoft.RecoveryServices/vaults@2021-08-01' = {
  name: rsvName
  location: resourceGroup().location
  sku: {
    name: rsvSku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

resource backupConfig 'Microsoft.RecoveryServices/vaults/backupconfig@2021-08-01' = {
  name: 'vaultconfig'
  location: resourceGroup().location
  parent: rsv
  properties: {
    softDeleteFeatureState: 'Enabled'
    storageModelType: rsvStorageType
    storageType: rsvStorageType
  }
}

resource backupStorageConfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2021-08-01' = {
  name: 'vaultstorageconfig'
  location: resourceGroup().location
  parent: rsv
  properties: {
    crossRegionRestoreFlag: false
    storageModelType: rsvStorageType
    storageType: rsvStorageType
  }
}
