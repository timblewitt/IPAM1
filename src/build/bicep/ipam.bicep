param lzName string
param regionName string
param regionId string
param rgIpamName string
param rgNetworkName string
param rgSharedSvcsName string

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

resource rgSharedSvcs 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgSharedSvcsName
  location: regionName
}

resource rgNetwork 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgNetworkName
  location: regionName
}

module sa './modules/ipam/sa.bicep' = {
  name: 'saDeployment'
  scope: rgIpam
  params: {
    saName: 'sa${uniqueString(rgIpam.id)}ipam'
    saSku: 'Standard_LRS'
    saKind: 'StorageV2'
  }
}

//module vnet './modules/ipam/network.bicep' = if (aseDeploy == true) {
//  name: 'vnetDeployment'
//  scope: rgNetwork
//  params: {
//    vnetName: aseVnetName
//    vnetAddress: aseVnetAddress
//    snetName: aseSnetName
//    snetAddress: aseSnetAddress
//  }
//}

module law './modules/ipam/law.bicep' = {
  name: 'lawDeployment'
  scope: rgSharedSvcs
  params: {
    lawName: 'law-${lzName}-${regionId}-central'
  }
}

//module ase './modules/ipam/ase.bicep' = if (aseDeploy == true) {
//  name: 'aseDeployment'
//  scope: rgIpam
//  params: {
//    aseName: 'ase-${lzName}-${regionId}-ipam'
//    aseVnetId: aseDeploy ? vnet.outputs.snetId : ''
//  }
//}

module asp './modules/ipam/asp.bicep' = {
  name: 'aspDeployment'
  scope: rgIpam
  params: {
    aspName: 'asp-${lzName}-${regionId}-ipam'
    aspSkuName: aseDeploy ? 'I1' : 'EP1'
    aspTier: aseDeploy ? 'Isolated' : 'Premium'
//    aseId: aseDeploy ? ase.outputs.aseId : ''
  }
}

module fa './modules/ipam/fa.bicep' = {
  name: 'faDeployment'
  scope: rgIpam
  params: {
    faName: 'fa-${lzName}-${regionId}-ipam'
    faAspId: asp.outputs.aspId
    faSaName: sa.outputs.saName
    faSaId: sa.outputs.saId
    faSaApiVersion: sa.outputs.saApiVersion
    lawId: law.outputs.lawId
  }
}

