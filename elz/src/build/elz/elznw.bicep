param elzSubName string
param elzRegionId string
param elzVnetName string
param elzVnetRg string
param elzVnetAddress string
param elzNsgRg string
param elzRegionName string
param snetWeb string
param snetApp string
param snetDb string
param snetCgTool string
param snetEcsTool string
param mgPolicyId string
param nwPolicyId string
param lockPolicyId string
param lockAdminRoleId string

targetScope = 'subscription'

resource rgNetwork 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzVnetRg
  location: elzRegionName
}

resource rgNsg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzNsgRg
  location: elzRegionName
}

module nsg './modules/nsg.bicep' = {
  name: 'nsgDeployment'
  scope: rgNsg
  params: {
    elzSubName: elzSubName
    elzRegionId: elzRegionId
    location: elzRegionName
  }
}

//module nwPolicy './modules/policynw.bicep' = {
//  name: 'nwPolicy'
//  scope: rgNetwork 
//  params: {
//    mgPolicyId: mgPolicyId
//    nwPolicyId: nwPolicyId
//    lockPolicyId: lockPolicyId
//    lockAdminRoleId: lockAdminRoleId
//    elzSubName: elzSubName
//    location: elzRegionName
//  }
//}

//module lockPolicy './modules/policylock.bicep' = {
//  name: 'lockPolicy'
//  scope: rgNetwork 
//  params: {
//    lockPolicyId: nwPolicy.outputs.lockPolAssId
//  }
//}

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
    location: elzRegionName
  } 
  //dependsOn: [
  //  nwPolicy
  //]
}

//module rgLock './modules/lock.bicep' = {
//  name: 'rgDeployment'
//  scope: rgNetwork  
//  dependsOn: [
//    vnet
//  ]
//}
