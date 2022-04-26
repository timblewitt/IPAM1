param mgmtSubName string
param ipamSubName string
param regionName string
param regionId string
param rgIpamName string
param rgMonitorName string

param aseDeploy bool = true
param aseVnetName string
param aseVnetAddress string
param aseSnetName string
param aseSnetAddress string

targetScope = 'subscription'

resource rgIpam 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgIpamName
  location: regionName
}

resource rgMonitor 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgMonitorName
  location: regionName
}

module st './modules/st.bicep' = {
  name: 'stDeployment'
  scope: rgIpam
  params: {
    stName: 'st${uniqueString(rgIpam.id)}ipam'
    stSku: 'Standard_LRS'
    stKind: 'StorageV2'
    location: regionName
  }
}

module vnet './modules/network.bicep' = if (aseDeploy == true) {
  name: 'vnetDeployment'
  scope: rgIpam
  params: {
    vnetName: aseVnetName
    vnetAddress: aseVnetAddress
    snetName: aseSnetName
    snetAddress: aseSnetAddress
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

module ase './modules/ase.bicep' = if (aseDeploy == true) {
  name: 'aseDeployment'
  scope: rgIpam
  params: {
    aseName: 'ase-${ipamSubName}-${regionId}-ipam'
    aseVnetId: aseDeploy ? vnet.outputs.snetId : ''
    location: regionName
  }
}

module plan './modules/plan.bicep' = {
  name: 'planDeployment'
  scope: rgIpam
  params: {
    planName: 'plan-${ipamSubName}-${regionId}-ipam'
    planSkuName: aseDeploy ? 'I1' : 'EP1'
    planTier: aseDeploy ? 'Isolated' : 'Premium'
    aseId: aseDeploy ? ase.outputs.aseId : ''
    location: regionName
  }
}

module fa './modules/fa.bicep' = {
  name: 'faDeployment'
  scope: rgIpam
  params: {
    faName: 'fa-${ipamSubName}-${regionId}-ipam'
    faplanId: plan.outputs.planId
    faStName: st.outputs.stName
    faStId: st.outputs.stId
    faStApiVersion: st.outputs.stApiVersion
    logId: log.outputs.logId
    location: regionName
  }
}

