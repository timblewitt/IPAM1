// Create policy assignments
// Created by the platform enablement team
// Scoped at management group level
// Version 1.0.0 31/12/2021

// SCOPE
targetScope = 'managementGroup'

// PARAMETERS
@description('Deployment location.')
param location string

@description('Custom Policy Defination ids from mgPolDef.bicep.')
param customPolicyIds array

param productsInscopeMGs array

param productsNotInscopeRGs array

// POLICY ASSIGNMENTS

// Policy - Allows products on the allow list, deny all others
module products_assignnment './r_products.bicep' = [ for productsInscopeMG in productsInscopeMGs: {
   name: 'products_assign-${productsInscopeMG.mgid}'
   scope: managementGroup(productsInscopeMG.mgid)
   params: {
     location: location
     productsCustomPolicyId: customPolicyIds[0] // maps to allowed products
     productsNotInscopeRGs: productsNotInscopeRGs 
   }
}]

// OUTPUTS
output productsAssignmentIds array = [ for (productsInscopeMG,i) in productsInscopeMGs:{
   id: products_assignnment[i].outputs.productsAssignmentId
}]
