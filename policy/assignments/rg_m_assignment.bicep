// SCOPE
targetScope = 'resourceGroup'

// PARAMETERS
param location string = 'UK South'
param networksCustomPolicyId string
param networksInscopeResourceGroups array = []


module rg_assignments_net './r_networks.bicep' = [ for networksInscopeResourceGroup in networksInscopeResourceGroups: {
  name: 'rg_assign_net-${networksInscopeResourceGroup.resourcegroup}'
  scope: resourceGroup(networksInscopeResourceGroup.subid, networksInscopeResourceGroup.resourcegroup)
  params: {
    location: location
    networksCustomPolicyId: networksCustomPolicyId // Allow network products
  }
}]

// OUTPUTS
output networkRGAssignmentIds array = [ for (networksInscopeResourceGroup,i) in networksInscopeResourceGroups: {
  id: rg_assignments_net[i].outputs.networkAssignmentId
}]
