// Create a resource lock
// Created by the platform enablement team
// Policy Definitions scoped at management group level
// Version 1.0.0 - 05 01 2022

// Parameters


resource createRgLock 'Microsoft.Authorization/locks@2017-04-01' = { 
  name: 'rgReadOnlyLock'
  properties: {
    level: 'ReadOnly'
    notes: 'Resource lock applied by Azure Landing Zone Automation'
  }
}

output lockId string = createRgLock.id
