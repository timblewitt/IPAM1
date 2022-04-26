// This is main bicep file to deploy resources at resource group scope
// version 1.0.0 30/12/2021

// SCOPE
targetScope = 'resourceGroup'

// PARAMETERS
param location string = 'UK South'
param networksCustomPolicyId string
param networksInscopeResourceGroups array = []

// ALLOWED NETWORKS RESOURCES IN APPROVED RESOURCE GROUPS
module rg_assignments './assignments/rg_m_assignment.bicep' = {
  name: 'rg_assignments'
  params: {
    location: location
    networksCustomPolicyId: networksCustomPolicyId
    networksInscopeResourceGroups: networksInscopeResourceGroups
  }
}

// Outputs
output rgAssignmentsForCleanUp array = [ // outputs here can be consumed by an .azcli script to delete deployed resources
  rg_assignments.outputs.networkRGAssignmentIds
]


