param vnetName string
param rgNetworkName string
param rgSharedSvcsName string
param regionName string
param vnetAddress string
param snetWeb string
param snetApp string
param snetDb string
param snetCgTool string
param snetEcsTool string

targetScope = 'subscription'
resource rgNetwork 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgNetworkName
  location: regionName
}

resource rgSharedSvcs 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgSharedSvcsName
  location: regionName
}

module vnet './modules/elz/network.bicep' = {
  name: 'vnetDeployment'
  scope: rgNetwork
  params: {
    vnetName: vnetName
    vnetAddress: vnetAddress
    snetWeb: snetWeb
    snetApp: snetApp
    snetDb: snetDb
    snetCgTool: snetCgTool
    snetEcsTool: snetEcsTool
  }
}

module sa './modules/elz/sa.bicep' = {
  name: 'saDeployment'
  scope: rgSharedSvcs
  params: {
    saName: 'sa${uniqueString(rgSharedSvcs.id)}diag'
    saSku: 'Standard_LRS'
    saKind: 'StorageV2'
  }
}
