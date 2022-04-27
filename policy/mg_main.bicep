// This is main bicep file to deploy resources at management group scope
// version 1.0.0 30/12/2021

// SCOPE
targetScope = 'managementGroup'

// PARAMETERS
param location string = 'UKSouth'
param ProductsExemptionCategory string = ''
param ProductsExemptionDisplayName string = ''
param ProductsExemptionDescription string = ''
param ProductsExemptionResourceGroups array = []
// Example ProductsExemptionResourceGroups values
// "resourcegroup": "rg-network-cg01",
// "subid": "194c9686-c3a0-448f-8ef3-cd0cb625210c"
param productsInscopeMGs array = []
param productsNotInscopeRGs array = []


// POLICY DEFINITIONS MODULE
module mg_definitions './definitions/mg_r_def.bicep' = {
  name: 'mg_definitions'
  params: {}
}
// returns output mg_definitions.outputs.customPolicyIds and mg_definitions.outputs.customPolicyNames

// // POLICY ASSIGNMENT MODULE
module mg_assignments './assignments/mg_m_assignment.bicep' = {
  name: 'mg_assignments'
  dependsOn: [
    mg_definitions
  ]
  params: {
    location: location
    customPolicyIds: mg_definitions.outputs.customPolicyIds
    productsInscopeMGs: productsInscopeMGs
    productsNotInscopeRGs: productsNotInscopeRGs
  }
}
// returns outputs mg_assignments.outputs.productsAssignmentIds


// // POLICY EXEMPTIONS MODULE - Allow Products Exemption
module mg_exemptions_prod './exemptions/mg_m_exemptions.bicep' = [ for (productsInscopeMG,i) in productsInscopeMGs: {
  name: 'mg_exemptions_prod-${productsInscopeMG.mgid}'
  dependsOn: [
    mg_assignments
  ]
  params: {
    // Product exemptions
    ExemptionResourceGroups: ProductsExemptionResourceGroups
    ExemptionPolicyAssignmentId: mg_assignments.outputs.productsAssignmentIds[i].id // exemption for allow products list
    //exemptionPolicyDefinitionReferenceIds: mg_definitions.outputs.customPolicyIds[0]
    ExemptionCategory: ProductsExemptionCategory
    ExemptionDisplayName: ProductsExemptionDisplayName
    ExemptionDescription: ProductsExemptionDescription
  }
}]

// OUTPUTS
output productExemptionsForCleanUp array = [ for (productsInscopeMG,i) in productsInscopeMGs:{
  id: mg_exemptions_prod[i].outputs.ExemptionsIds
}]

output productAssignmentsForCleanUp array = [
  mg_assignments.outputs.productsAssignmentIds
]


output policyDefsForCleanUp array = [ // outputs here can be consumed by an .azcli script to delete deployed resources
  mg_definitions.outputs.customPolicyIds
]
