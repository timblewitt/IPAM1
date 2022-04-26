targetScope = 'managementGroup'

resource namingpolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Enforce naming convention' 
  properties: {
    displayName: 'Enforce Naming Convention'    
    parameters: {
      subId: {
        type: 'string'
      } 
      regionId: {
        type: 'string'
        defaultValue: 'uks'
      }
    }
    policyType: 'Custom'
    policyRule: { 
      if: {
        anyOf: [
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.Network/virtualNetworks'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'vnet-\',parameters(\'subId\'),\'-\',parameters(\'regionId\'),\'-*\')]'
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.KeyVault/vaults'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'kv-\',parameters(\'subId\'),\'-\',parameters(\'regionId\'),\'-*\')]'
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.Automation/automationAccounts'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'aa-\',parameters(\'subId\'),\'-\',parameters(\'regionId\'),\'-*\')]'
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.OperationalInsights/workspaces'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'log-\',parameters(\'subId\'),\'-\',parameters(\'regionId\'),\'-*\')]'
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.Network/networkSecurityGroups'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'nsg-\',parameters(\'subId\'),\'-\',parameters(\'regionId\'),\'-*\')]'
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.Network/routeTables'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'rt-\',parameters(\'subId\'),\'-\',parameters(\'regionId\'),\'-*\')]'
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.Storage/storageAccounts'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'st*\')]'
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.RecoveryServices/vaults'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'rsv-\',parameters(\'subId\'),\'-\',parameters(\'regionId\'),\'-*\')]'
                    }
                  ]
                }
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}
