
param elzSubName string
param elzRegionId string
param elzVnetName string
param elzVnetRg string
param elzVnetAddress string
param elzNsgRg string
param elzManagementRg string
param elzRegionName string
param snetWeb string
param snetApp string
param snetDb string
param snetCgTool string
param snetEcsTool string

targetScope = 'subscription'

resource rgNetwork 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzVnetRg
  location: elzRegionName
}

//module rgLock './modules/lock.bicep' = {
//  name: 'rgDeployment'
//  scope: rgNetwork  
//  dependsOn: [
//    vnet
//  ]
//}

resource rgNsg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzNsgRg
  location: elzRegionName
}

resource rgManagement 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzManagementRg
  location: elzRegionName
}

module nsg './modules/nsg.bicep' = {
  name: 'nsgDeployment'
  scope: rgNsg
  params: {
    elzSubName: elzSubName
    elzRegionId: elzRegionId
  }
}

module vnet './modules/network.bicep' = {
  name: 'vnetDeployment'
  scope: rgNetwork
  params: {
    elzSubName: elzSubName
    elzRegionId: elzRegionId
    vnetName: elzVnetName
    vnetAddress: elzVnetAddress
    snetWeb: snetWeb
    snetApp: snetApp
    snetDb: snetDb
    snetCgTool: snetCgTool
    snetEcsTool: snetEcsTool
    nsgWebId: nsg.outputs.nsgWebId
    nsgAppId: nsg.outputs.nsgAppId
    nsgDbId: nsg.outputs.nsgDbId
    nsgCgToolId: nsg.outputs.nsgCgToolId
    nsgEcsToolId: nsg.outputs.nsgEcsToolId
  }
}

module st './modules/st.bicep' = {
  name: 'stDeployment'
  scope: rgManagement
  params: {
    stName: 'st${uniqueString(rgManagement.id)}diag'
    stSku: 'Standard_LRS'
    stKind: 'StorageV2'
  }
}

module rsv './modules/rsv.bicep' = {
  name: 'rsvDeployment'
  scope: rgManagement
  params: {
    rsvName: 'rsv-${elzSubName}-${elzRegionId}-01'
  }
}

module log './modules/log.bicep' = {
  name: 'logDeployment'
  scope: rgManagement
  params: {
    logName: 'log-${elzSubName}-${elzRegionId}-01'
    aaId: aa.outputs.aaId
  }
}

module kv './modules/kv.bicep' = {
  name: 'kvDeployment'
  scope: rgManagement
  params: {
    kvName: 'kv-${elzSubName}-${elzRegionId}-01'
  }
}

module aa './modules/aa.bicep' = {
  name: 'aaDeployment'
  scope: rgManagement
  params: {
    aaName: 'aa-${elzSubName}-${elzRegionId}-01'
  }
}
