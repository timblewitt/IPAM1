targetScope = 'subscription'

resource namingrgpolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Enforce RG naming convention' 
  properties: {
    displayName: 'Enforce RG Naming Convention'    
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
                equals: 'Microsoft.Resources/subscriptions/resourceGroups'
              }
              {
                not: {
                  anyOf: [
                    {
                      field: 'name'
                      like: '[concat(\'rg-\',parameters(\'subId\'),\'-\',parameters(\'regionId\'),\'-*\')]'
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
