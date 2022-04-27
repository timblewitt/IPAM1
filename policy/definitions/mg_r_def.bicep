// Create custom policy definations
// Created by the platform enablement team
// Policy Definitions scoped at management group level
// Version 1.0.0 - 30 12 2021

// scope
targetScope = 'managementGroup'

// Parameters


// Variables
var deploy_allowed_products = json(loadTextContent('./custom/deploy_allowed_products.json'))
var deploy_allowed_products_networks = json(loadTextContent('./custom/deploy_allowed_products_networks.json'))

// Custom Definitions

// Policy - Requirement 6, only, enforce a corporate standard - Only allow azure services that have been through the pattern approval proccess
resource deployAllowedProducts 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_allowed_products'
  properties: deploy_allowed_products.properties
}

// Policy - Requirement 1, enforce a corporate standard - Allow virtual network creation in approved resource groups
resource deployAllowProductsNetwork 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_allowed_products_networks'
  properties: deploy_allowed_products_networks.properties
}


// Outputs
output customPolicyIds array = [
  deployAllowedProducts.id
  deployAllowProductsNetwork.id
]

output customPolicyNames array = [
  deploy_allowed_products.properties.displayName
  deploy_allowed_products_networks.properties.displayName
]
