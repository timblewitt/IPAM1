
param elzSubName string
param elzRegionId string
param elzVnetName string
param elzVnetRg string
param elzVnetAddress string
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

resource rgManagement 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzManagementRg
  location: elzRegionName
}

module vnet './modules/network.bicep' = {
  name: 'vnetDeployment'
  scope: rgNetwork
  params: {
    vnetName: elzVnetName
    vnetAddress: elzVnetAddress
    snetWeb: snetWeb
    snetApp: snetApp
    snetDb: snetDb
    snetCgTool: snetCgTool
    snetEcsTool: snetEcsTool
  }
}

module sa './modules/sa.bicep' = {
  name: 'saDeployment'
  scope: rgManagement
  params: {
    saName: 'sa${uniqueString(rgManagement.id)}diag'
    saSku: 'Standard_LRS'
    saKind: 'StorageV2'
  }
}

module rsv './modules/rsv.bicep' = {
  name: 'rsvDeployment'
  scope: rgManagement
  params: {
    rsvName: 'rsv-${elzSubName}-${elzRegionId}-01'
  }
}

module law './modules/law.bicep' = {
  name: 'lawDeployment'
  scope: rgManagement
  params: {
    lawName: 'law-${elzSubName}-${elzRegionId}-01'
  }
}

module kv './modules/kv.bicep' = {
  name: 'kvDeployment'
  scope: rgManagement
  params: {
    kvName: 'kv-${elzSubName}-${elzRegionId}-01'
  }
}
