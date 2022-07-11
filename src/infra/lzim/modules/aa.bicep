param aaName string
param location string 

resource aa 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: aaName
  location: location
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
