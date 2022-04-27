// Currently not inuse

// SCOPE
targetScope = 'resourceGroup'

// PARAMETERS
param location string = 'UKSouth'
param networksCustomPolicyId string

resource networks_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'networks_assignment' // must not exceed 24 characters
  location: location
  properties: {
    displayName: 'Allow Network Resources - Governance Assignment - RG Scope'
    description: 'Allow Network Resources - Governance Assignment - RG Scope'
    enforcementMode: 'Default'
    metadata: {
      source: 'ELZ'
     version: '1.0.0'
    }
    policyDefinitionId: networksCustomPolicyId // maps to allowed networks def
  }
}

// OUTPUTS
output networkAssignmentId string = networks_assignment.id
