param rsvName string
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param rsvStorageType string = 'GeoRedundant'
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
  
  resource backupConfig 'backupconfig' = {
    name: 'vaultconfig'
    location: resourceGroup().location
    properties: {
      softDeleteFeatureState: 'Enabled'
      storageModelType: rsvStorageType
      storageType: rsvStorageType
    }
  }
    
  resource backupStorageConfig 'backupstorageconfig' = {
    name: 'vaultstorageconfig'
    location: resourceGroup().location
    properties: {
      crossRegionRestoreFlag: false
      storageModelType: rsvStorageType
      storageType: rsvStorageType
    }
  }
}

