targetScope = 'subscription'

param namingPolicyId string
param elzSubName string
param elzRegionId string

resource namingpolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Enforce Landing Zone naming convention' 
  properties: {
    enforcementMode: 'Default'
    displayName: 'Enforce Landing Zone Naming Convention'  
    policyDefinitionId: namingPolicyId  
    parameters: {
      subId: {
        value: elzSubName
      } 
      regionId: {
        value: elzRegionId
      }
    }
  }
}
