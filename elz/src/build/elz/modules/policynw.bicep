param mgPolicyId string
param nwPolicyId string
param lockPolicyId string
param lockAdminRoleId string
param elzSubName string
param location string 

resource rgPolExempt 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: 'Exempt network RG'
  properties: {
    exemptionCategory: 'Waiver'
    policyAssignmentId: mgPolicyId
  }
}

resource nwpolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Allow network resources' 
  location: location
  properties: {
    enforcementMode: 'Default'
    displayName: 'AllowNetworkResources'
    policyDefinitionId: nwPolicyId
  }
  dependsOn: [
    rgPolExempt
  ]
}

resource lockpolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: guid('LockPolicy', elzSubName) 
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enforcementMode: 'Default'
    displayName: 'EnforceNetworkGroupLock'
    policyDefinitionId: lockPolicyId
  }
  dependsOn: [
    rgPolExempt
  ]
}

resource lockadmin 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('LockAdmin', elzSubName) 
  properties: {
    principalId: lockpolicy.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: lockAdminRoleId 
  }
}

output lockPolAssId string = lockpolicy.id
