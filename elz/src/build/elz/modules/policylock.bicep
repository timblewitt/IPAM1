param lockPolicyId string

resource remediation 'Microsoft.PolicyInsights/remediations@2021-10-01' = {
  name: 'DeployIfNotExists'
  properties: {
    policyAssignmentId: lockPolicyId
    resourceDiscoveryMode: 'ReEvaluateCompliance'
    parallelDeployments: 10
  }
}
