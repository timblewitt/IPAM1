param elzSubName string
param elzRegionId string
param location string 

resource nsgWeb 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: 'nsg-${elzSubName}-${elzRegionId}-web'
  location: location
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
  location: location
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
  location: location
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
  location: location
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
  location: location
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

output nsgWebId string = nsgWeb.id
output nsgAppId string = nsgApp.id
output nsgDbId string = nsgDb.id
output nsgCgToolId string = nsgCgTool.id
output nsgEcsToolId string = nsgEcsTool.id
