// Create policy exemptions to exclude certain scopes from assignments
// These exemptions are for assignments made at management group level
// Created by the platform enablement team
// Version 1.0.0 - 31 12 2021

// SCOPE
targetScope = 'managementGroup'

// PARAMETERS
param ExemptionPolicyAssignmentId string
param ExemptionCategory string
param ExemptionDisplayName string
param ExemptionDescription string
param ExemptionResourceGroups array

// // POLICY EXEMPTIONS MODULE - Products Allow
module exemptions './r_products.bicep' = [ for exemptionResourceGroup in ExemptionResourceGroups: {
  scope: resourceGroup(exemptionResourceGroup.subid, exemptionResourceGroup.resourcegroup)
  name: 'Exemptions-${exemptionResourceGroup.resourcegroup}'
  params: {
    exemptionPolicyAssignmentId: ExemptionPolicyAssignmentId // deny_vnet_assignment
    //exemptionPolicyDefinitionReferenceIds: mg_definitions.outputs.customPolicyIds[0]
    exemptionCategory: ExemptionCategory
    exemptionDisplayName: ExemptionDisplayName
    exemptionDescription: ExemptionDescription
  }
}]

// OUTPUTS
output ExemptionsIds array = [ for (exemptionResourceGroup,i) in ExemptionResourceGroups: {
  id: exemptions[i].outputs.exemptionId
}]
  
