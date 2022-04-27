// Network initiative
// Currently not inuse

// SCOPE
targetScope = 'managementGroup'

// PARAMETERS
param location string = 'UKSouth'
param customInitiativeId string

// Policy - Requirement 7, enforce a corporate standard - Deny public ip addresses
resource network_init_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'network_init_assignment' // must not exceed 24 characters
  location: location
  properties: {
    displayName: 'Network Initiative - Governance Assignment - MG Scope'
    description: 'Network Initiative - Governance Assignment - MG Scope'
    enforcementMode: 'Default'
    metadata: {
      source: 'ELZ'
      version: '1.0.0'
    }
    policyDefinitionId: customInitiativeId // maps to network initiative
  }
}

// OUTPUTS
output inetworkAssignmentId string = network_init_assignment.id
