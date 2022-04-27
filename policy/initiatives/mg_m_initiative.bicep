// Create policy sets from custom definitions
// Created by the platform enablement team
// Policy Sets scoped at management group level
// Version 1.0.0 - 31 12 2021

// SCOPE
targetScope = 'managementGroup'

// PARAMETERS
param policyCategory string = 'Bespoke'
param customPolicyIds array
param customPolicyNames array

// POLICYSETS MODULES

module network_initiative './mg_r_network.bicep' = {
  name: 'network_initiative'
  params: {
    policyCategory: policyCategory
    customPolicyIds: customPolicyIds
    customPolicyNames: customPolicyNames
  }
}

// OUTPUTS
output customInitiativeIds array = [
  network_initiative.outputs.customInitiativeIds // network initiative id
]
