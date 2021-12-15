
param mgmtSubName string
param connSubName string
param regionName string
param regionId string
param rgNetworkName string
param rgManagementName string

param aseDeploy bool = true
//param aseVnetName string
//param aseVnetAddress string
//param aseSnetName string
//param aseSnetAddress string

targetScope = 'subscription'
//resource rgIpam 'Microsoft.Resources/resourceGroups@2021-04-01' = {
//  name: rgIpamName
//  location: regionName
//}

resource rgManagement 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgManagementName
  location: regionName
}

resource rgNetwork 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgNetworkName
  location: regionName
}

module sa './modules/sa.bicep' = {
  name: 'saDeployment'
  scope: rgNetwork
  params: {
    saName: 'sa${uniqueString(rgNetwork.id)}ipam'
    saSku: 'Standard_LRS'
    saKind: 'StorageV2'
  }
}

//module vnet './modules/network.bicep' = if (aseDeploy == true) {
//  name: 'vnetDeployment'
//  scope: rgNetwork
//  params: {
//    vnetName: aseVnetName
//    vnetAddress: aseVnetAddress
//    snetName: aseSnetName
//    snetAddress: aseSnetAddress
//  }
//}

module law './modules/law.bicep' = {
  name: 'lawDeployment'
  scope: rgManagement
  params: {
    lawName: 'law-${connSubName}-${regionId}-central'
  }
}

//module ase './modules/ase.bicep' = if (aseDeploy == true) {
//  name: 'aseDeployment'
//  scope: rgNetwork
//  params: {
//    aseName: 'ase-${connSubName}-${$regionId}-ipam'
//    aseVnetId: aseDeploy ? vnet.outputs.snetId : ''
//  }
//}

module asp './modules/asp.bicep' = {
  name: 'aspDeployment'
  scope: rgNetwork
  params: {
    aspName: 'asp-${connSubName}-${regionId}-ipam'
    aspSkuName: aseDeploy ? 'I1' : 'EP1'
    aspTier: aseDeploy ? 'Isolated' : 'Premium'
//    aseId: aseDeploy ? ase.outputs.aseId : ''
  }
}

module fa './modules/fa.bicep' = {
  name: 'faDeployment'
  scope: rgNetwork
  params: {
    faName: 'fa-${connSubName}-${regionId}-ipam'
    faAspId: asp.outputs.aspId
    faSaName: sa.outputs.saName
    faSaId: sa.outputs.saId
    faSaApiVersion: sa.outputs.saApiVersion
    lawId: law.outputs.lawId
  }
}

