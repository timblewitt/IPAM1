
param mgmtSubName string
param connSubName string
param regionName string
param regionId string
param rgNetworkName string
param rgManagementName string

param aseDeploy bool = true
param aseVnetName string
param aseVnetAddress string
param aseSnetName string
param aseSnetAddress string

targetScope = 'subscription'

resource rgNetwork 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgNetworkName
  location: regionName
}

resource rgManagement 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgManagementName
  location: regionName
}

module st './modules/st.bicep' = {
  name: 'stDeployment'
  scope: rgNetwork
  params: {
    stName: 'st${uniqueString(rgNetwork.id)}ipam'
    stSku: 'Standard_LRS'
    stKind: 'StorageV2'
    location: regionName
  }
}

module vnet './modules/network.bicep' = if (aseDeploy == true) {
  name: 'vnetDeployment'
  scope: rgNetwork
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
  scope: rgManagement
  params: {
    logName: 'log-${mgmtSubName}-${regionId}-01'
    aaId: aa.outputs.aaId
    location: regionName
  }
}

module aa './modules/aa.bicep' = {
  name: 'aaDeployment'
  scope: rgManagement
  params: {
    aaName: 'aa-${mgmtSubName}-${regionId}-01'
    location: regionName
  }
}

module ase './modules/ase.bicep' = if (aseDeploy == true) {
  name: 'aseDeployment'
  scope: rgNetwork
  params: {
    aseName: 'ase-${connSubName}-${regionId}-ipam'
    aseVnetId: aseDeploy ? vnet.outputs.snetId : ''
    location: regionName
  }
}

module plan './modules/plan.bicep' = {
  name: 'planDeployment'
  scope: rgNetwork
  params: {
    planName: 'plan-${connSubName}-${regionId}-ipam'
    planSkuName: aseDeploy ? 'I1' : 'EP1'
    planTier: aseDeploy ? 'Isolated' : 'Premium'
    aseId: aseDeploy ? ase.outputs.aseId : ''
    location: regionName
  }
}

module fa './modules/fa.bicep' = {
  name: 'faDeployment'
  scope: rgNetwork
  params: {
    faName: 'fa-${connSubName}-${regionId}-ipam'
    faplanId: plan.outputs.planId
    faStName: st.outputs.stName
    faStId: st.outputs.stId
    faStApiVersion: st.outputs.stApiVersion
    logId: log.outputs.logId
    location: regionName
  }
}

