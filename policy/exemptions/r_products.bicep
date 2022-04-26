// Exemption for allow list

// PARAMETERS
param exemptionPolicyAssignmentId string
//param exemptionPolicyDefinitionReferenceIds string
param exemptionCategory string = 'Mitigated'
param exemptionDisplayName string
param exemptionDescription string

// RESOURCES
resource allow_list_exemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: 'allow_list_exemption'
  properties: {
    policyAssignmentId: exemptionPolicyAssignmentId
    //policyDefinitionReferenceIds: [
    //  exemptionPolicyDefinitionReferenceIds
    //]
    exemptionCategory: exemptionCategory
    displayName: exemptionDisplayName
    description: exemptionDescription
    metadata: {
      version: '1.0.0'
    }
  }
}

// OUTPUTS
output exemptionId string = allow_list_exemption.id
