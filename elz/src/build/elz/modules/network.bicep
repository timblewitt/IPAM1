param elzSubName string
param elzRegionId string
param vnetName string
param vnetAddress string
param snetWeb string
param snetApp string
param snetDb string
param snetCgTool string
param snetEcsTool string 
param nsgWebId string
param nsgAppId string
param nsgDbId string
param nsgCgToolId string
param nsgEcsToolId string
param location string 

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnetName
  location: location
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
            id: nsgWebId
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
            id: nsgAppId
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
            id: nsgDbId
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
            id: nsgCgToolId
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
            id: nsgEcsToolId
          }
          routeTable: {
            id: rt.id
          }
        }
      }
    ]
  }
}

resource rt 'Microsoft.Network/routeTables@2021-03-01' = {
  name: 'rt-${elzSubName}-${elzRegionId}-01'
  location: location
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
