
param elzSubName string
param elzRegionId string
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
          networkSecurityGroup: {
            id: nsgWeb.id
          }
          routeTable: {
            id: rt.id
          }
        }
      }
      {
        id: 'snetApp'
        name: 'snet-app'
        properties: {
          addressPrefix: snetApp
          networkSecurityGroup: {
            id: nsgApp.id
          }
          routeTable: {
            id: rt.id
          }
        }
      }
      {
        id: 'snetDb'
        name: 'snet-db'
        properties: {
          addressPrefix: snetDb
          networkSecurityGroup: { 
            id: nsgDb.id
          }
          routeTable: {
            id: rt.id
          }
        }
      }
      {
        id: 'snetCgTool'
        name: 'snet-cgtool'
        properties: {
          addressPrefix: snetCgTool
          networkSecurityGroup: { 
            id: nsgCgTool.id
          }
          routeTable: {
            id: rt.id
          }
        }
      }
      {
        id: 'snetEcsTool'
        name: 'snet-ecstool'
        properties: {
          addressPrefix: snetEcsTool
          networkSecurityGroup: { 
            id: nsgEcsTool.id
          }
          routeTable: {
            id: rt.id
          }
        }
      }
    ]
  }
}

resource nsgWeb 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: 'nsg-${elzSubName}-${elzRegionId}-web'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
      name: 'Drop_All'
      properties: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
        access: 'Deny'
        priority: 4096
        direction: 'Inbound'
        }      
      }
    ]
  }
}

resource nsgApp 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: 'nsg-${elzSubName}-${elzRegionId}-app'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
      name: 'Drop_All'
      properties: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
        access: 'Deny'
        priority: 4096
        direction: 'Inbound'
        }      
      }
    ]
  }
}

resource nsgDb 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: 'nsg-${elzSubName}-${elzRegionId}-db'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
      name: 'Drop_All'
      properties: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
        access: 'Deny'
        priority: 4096
        direction: 'Inbound'
        }      
      }
    ]
  }
}

resource nsgCgTool 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: 'nsg-${elzSubName}-${elzRegionId}-cgtool'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
      name: 'Drop_All'
      properties: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
        access: 'Deny'
        priority: 4096
        direction: 'Inbound'
        }      
      }
    ]
  }
}

resource nsgEcsTool 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: 'nsg-${elzSubName}-${elzRegionId}-ecstool'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
      name: 'Drop_All'
      properties: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
        access: 'Deny'
        priority: 4096
        direction: 'Inbound'
        }      
      }
    ]
  }
}

resource rt 'Microsoft.Network/routeTables@2021-03-01' = {
  name: 'rt-${elzSubName}-${elzRegionId}-01'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'Default_route_to_Azure_Firewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '10.10.10.10'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
}
