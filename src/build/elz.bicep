param vnetName string
param rgNetworkName string
param regionName string
param addressRange string
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

module vnet './modules/network.bicep' = {
  name: 'vnetDeployment'
  scope: rgNetwork
  params: {
    vnetName: vnetName
    addressRange: addressRange
    snetWeb: snetWeb
    snetApp: snetApp
    snetDb: snetDb
    snetCgTool: snetCgTool
    snetEcsTool: snetEcsTool
  }
}
