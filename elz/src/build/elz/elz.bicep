param elzSubName string
param elzRegionId string
param elzRegionName string
param elzMonitorRg string
param elzBackupRg string
param elzSecurityRg string
param elzAvdRg string
param elzType string
param namingPolicyId string

targetScope = 'subscription'

module subPolicy './modules/policysub.bicep' = {
  name: '${elzSubName}SubPolicyDeployment'
  params: {
    
    namingPolicyId: namingPolicyId
    elzSubName: elzSubName
    elzRegionId: elzRegionId
  }
}

resource rgMonitor 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzMonitorRg
  location: elzRegionName
}

resource rgBackup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzBackupRg
  location: elzRegionName
}

resource rgSecurity 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzSecurityRg
  location: elzRegionName
}

resource rgAvd 'Microsoft.Resources/resourceGroups@2021-04-01' = if(elzType == 'AVD') {
  name: elzAvdRg
  location: elzRegionName
}

module stdiag './modules/st.bicep' = {
  name: 'stDiagDeployment'
  scope: rgMonitor
  params: {
    stName: 'st${uniqueString(rgMonitor.id)}diag'
    stSku: 'Standard_LRS'
    stKind: 'StorageV2'
    location: elzRegionName
  }
}

module stavd './modules/st.bicep' = if(elzType == 'AVD') {
  name: 'stAvdDeployment'
  scope: rgAvd
  params: {
    stName: 'st${uniqueString(rgMonitor.id)}avd'
    stSku: 'Standard_LRS'
    stKind: 'StorageV2'
    location: elzRegionName
  }
}

module rsv './modules/rsv.bicep' = {
  name: 'rsvDeployment'
  scope: rgBackup
  params: {
    rsvName: 'rsv-${elzSubName}-${elzRegionId}-01'
    location: elzRegionName
  }
}

module rsvcfg './modules/rsvcfg.bicep' = {
  name: 'rsvcfgDeployment'
  scope: rgBackup
  params: {
    rsvName: rsv.outputs.rsvName
    rsvStorageType: 'GeoRedundant'
    location: elzRegionName
  }
}

module log './modules/log.bicep' = {
  name: 'logDeployment'
  scope: rgMonitor
  params: {
    logName: 'log-${elzSubName}-${elzRegionId}-01'
    aaId: aa.outputs.aaId
    location: elzRegionName
  }
}

module kv './modules/kv.bicep' = {
  name: 'kvDeployment'
  scope: rgSecurity
  params: {
    kvName: 'kv-${elzSubName}-${elzRegionId}-01'
    location: elzRegionName
  }
}

module aa './modules/aa.bicep' = {
  name: 'aaDeployment'
  scope: rgMonitor
  params: {
    aaName: 'aa-${elzSubName}-${elzRegionId}-01'
    location: elzRegionName
  }
}
