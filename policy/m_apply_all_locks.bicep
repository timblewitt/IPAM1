// This bbicep file will deploy resource locks to all relevent RG's
// version 1.0.0 05/01/2022

// SCOPE
targetScope = 'managementGroup'

// PARAMETERS
param location string
param networksCustomPolicyId string
param networksInscopeResourceGroups array = []


// ALLOWED NETWORKS RESOURCES IN APPROVED RESOURCE GROUPS
module rg_deploy_all_locks './locks/r_resource_locks.bicep' = [ for networksInscopeResourceGroup in networksInscopeResourceGroups:{
  name: 'rg_deploy_all_locks'
  scope: resourceGroup(networksInscopeResourceGroup.subid, networksInscopeResourceGroup.resourcegroup)
}]

// Outputs
output rgLocksForCleanUp array = [ for (networksInscopeResourceGroup,i) in networksInscopeResourceGroups:{ // outputs here can be consumed by an .azcli script to delete deployed resources
  id: rg_deploy_all_locks[i].outputs.lockId
}]
