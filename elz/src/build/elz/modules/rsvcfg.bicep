param rsvName string
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param rsvStorageType string = 'LocallyRedundant'
param location string 

resource backupConfig 'Microsoft.RecoveryServices/vaults/backupconfig@2021-10-01' = {
  name: '${rsvName}/vaultconfig'
  location: location
  properties: {
    softDeleteFeatureState: 'Enabled'
    storageModelType: rsvStorageType
    storageType: rsvStorageType
  }
}
  
resource backupStorageConfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2021-10-01' = {
  name: '${rsvName}/vaultstorageconfig'
  location: location
  properties: {
    crossRegionRestoreFlag: false
    storageModelType: rsvStorageType
    storageType: rsvStorageType
  }
}

