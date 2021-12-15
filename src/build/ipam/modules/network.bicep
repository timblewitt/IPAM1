param vnetName string
param vnetAddress string
param snetName string
param snetAddress string

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
        name: snetName
        properties: {
          addressPrefix: snetAddress
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output snetId string = vnet.properties.subnets[0].id
