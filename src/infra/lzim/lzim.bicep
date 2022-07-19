param mgmtSubName string
param regionName string
param regionId string
param rgLzimName string
param rgMonitorName string

targetScope = 'subscription'

resource rgLzim 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgLzimName
  location: regionName
}

resource rgMonitor 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgMonitorName
  location: regionName
}

module st './modules/st.bicep' = {
  name: 'stDeployment'
  scope: rgLzim
  params: {
    stName: 'st${uniqueString(rgLzim.id)}lzim'
    stSku: 'Standard_GRS'
    stKind: 'StorageV2'
    location: regionName
  }
}

module log './modules/log.bicep' = {
  name: 'logDeployment'
  scope: rgMonitor
  params: {
    logName: 'log-${mgmtSubName}-${regionId}-01'
    aaId: aa.outputs.aaId
    location: regionName
  }
}

module aa './modules/aa.bicep' = {
  name: 'aaDeployment'
  scope: rgMonitor
  params: {
    aaName: 'aa-${mgmtSubName}-${regionId}-01'
    location: regionName
  }
}

module plan './modules/plan.bicep' = {
  name: 'planDeployment'
  scope: rgLzim
  params: {
    planName: 'plan-${mgmtSubName}-${regionId}-lzim'
    planSkuName: 'EP1'
    planTier: 'Premium'
    location: regionName
  }
}

module fa './modules/fa.bicep' = {
  name: 'faDeployment'
  scope: rgLzim
  params: {
    faName: 'fa-${mgmtSubName}-${regionId}-lzim'
    faplanId: plan.outputs.planId
    faStName: st.outputs.stName
    faStId: st.outputs.stId
    faStApiVersion: st.outputs.stApiVersion
    logId: log.outputs.logId
    location: regionName
  }
}

