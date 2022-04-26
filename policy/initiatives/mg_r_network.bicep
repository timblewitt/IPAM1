targetScope = 'managementGroup'

// PARAMETERS
param policyCategory string = 'Custom'
param customPolicyIds array
param customPolicyNames array

// CUSTOM POLICYSETS
resource mg_r_network 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'mg_r_network'
  properties: {
    policyType: 'Custom'
    displayName: 'Governance Network Initiative - MG Scope'
    description: 'Management Network Governance Initiative - MG Scope'
    metadata: {
      category: policyCategory
      version: '1.0.0'
    }
    policyDefinitions: [
      {
        policyDefinitionId: customPolicyIds[1] // Deny Public IP
        policyDefinitionReferenceId: customPolicyNames[1] // Deny Public IP
        parameters: {}
      }
    ]
  }
}

// OUTPUTS
output customInitiativeIds string = mg_r_network.id
