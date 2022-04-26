// Create policy assignments
// Created by the platform enablement team
// Scoped at subscriptio level
// Version 1.0.0 31/12/2021

// Currently not in use

// SCOPE
targetScope = 'subscription'

// PARAMETERS
param location string = 'UKSouth'
param productsCustomPolicyId string
param productsInscopeSubscriptions array = []

// ASSIGMENTS MODULE

// ALLOWED PRODUCTS LIST, DENY ALL OTHER SERVICES
// TODO NEED TO MOVED TO MG SCOPE
// module products_assignnment './r_products.bicep' = [ for productsInscopeSubscription in productsInscopeSubscriptions: {
//   name: 'products_assign-${productsInscopeSubscription.subid}'
//   scope: subscription(productsInscopeSubscription.subid)
//   params: {
//     location: location
//     productsCustomPolicyId: productsCustomPolicyId // maps to allowed products
//   }
// }]

// // OUTPUTS
// output productsAssignmentIds array = [ for (productsInscopeSubscription,i) in productsInscopeSubscriptions: {
//   id: products_assignnment[i].outputs.productsAssignmentId
// }]

