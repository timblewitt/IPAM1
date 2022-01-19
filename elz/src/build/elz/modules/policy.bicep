
param mgPolicyId string
param nwPolicyId string

resource rgPolExempt 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: 'Exempt network RG'
  properties: {
    exemptionCategory: 'Mitigated'
    policyAssignmentId: mgPolicyId
  }
}

resource policy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Allow network resources' 
  location: resourceGroup().location
  properties: {
    enforcementMode: 'Default'
    policyDefinitionId: nwPolicyId
  }
  dependsOn: [
    rgPolExempt
  ]
}
