// Deploy Allow products list assignment

// SCOPE
targetScope = 'managementGroup'

// PARAMETERS
param location string = 'UKSouth'
param productsCustomPolicyId string
param productsNotInscopeRGs array

resource products_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'products_assignment' // must not exceed 24 characters
  location: location
  properties: {
    displayName: 'Allowed Products (Deny) - Governance Assignment - MG Scope'
    description: 'Allowed Products (Deny) - Governance Assignment - MG Scope'
    enforcementMode: 'Default'
    metadata: {
      source: 'ELZ'
     version: '1.0.0'
    }
    policyDefinitionId: productsCustomPolicyId // maps to allowed products
    notScopes: productsNotInscopeRGs 
  }
}

// OUTPUTS
output productsAssignmentId string = products_assignment.id
