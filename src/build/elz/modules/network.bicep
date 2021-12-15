param vnetName string
param vnetAddress string
param snetWeb string
param snetApp string
param snetDb string
param snetCgTool string
param snetEcsTool string 

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddress
      ]
    }
    subnets: [
      {
        id: 'snetWeb'
        name: 'snet-web'
        properties: {
          addressPrefix: snetWeb
        }
      }
      {
        id: 'snetApp'
        name: 'snet-app'
        properties: {
          addressPrefix: snetApp
        }
      }
      {
        id: 'snetDb'
        name: 'snet-db'
        properties: {
          addressPrefix: snetDb
        }
      }
      {
        id: 'snetCgTool'
        name: 'snet-cgtool'
        properties: {
          addressPrefix: snetCgTool
        }
      }
      {
        id: 'snetEcsTool'
        name: 'snet-ecstool'
        properties: {
          addressPrefix: snetEcsTool
        }
      }
    ]
  }
}
