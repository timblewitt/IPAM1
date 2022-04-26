// This is main bicep file to deploy resources at subscription scope
// version 1.0.0 30/12/2021

// SCOPE
targetScope = 'subscription'

// PARAMETERS
param location string = 'UKSouth'
param productsCustomPolicyId string
param productsInscopeSubscriptions array = []


module sub_assignments './assignments/sub_m_assignment.bicep' = {
  name: 'sub_assignments'
  params: {
    location: location
    productsCustomPolicyId: productsCustomPolicyId
    productsInscopeSubscriptions: productsInscopeSubscriptions
  }
}

// Allowed products networks
// module rg_assignments_net './assignments/rgPolAssignment.bicep' = [ for inscopeProductsNetworksResourceGroup in inscopeProductsNetworksResourceGroups: {
//   name: 'rg_assign_net-${inscopeProductsNetworksResourceGroup.resourcegroup}'
//   scope: resourceGroup(inscopeProductsNetworksResourceGroup.subid, inscopeProductsNetworksResourceGroup.resourcegroup)
//   params: {
//     location: location
//     customPolicyIds: allowProductsNetworksDefId
//     displayName: 'Allowed Products Networks (Deny)'
//     polDescription: 'Allowed Products Networks (Deny) - RG Scope'
//     polName: 'allowProductsNetworksRG'
//   }
// }]
