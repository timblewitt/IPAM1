param aaName string

resource aa 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: aaName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: false
    sku: {
      name: 'Basic'
    }
  }
}

output aaId string = aa.id
