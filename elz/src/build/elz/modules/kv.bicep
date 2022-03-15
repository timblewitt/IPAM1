param kvName string
param kvSkuName string = 'Standard'
param kvSoftDeleteRetentionDays int = 7
param location string

resource kv 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: kvName
  location: location
  properties: {
    enabledForDeployment: false
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: false 
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    publicNetworkAccess: 'Disabled'
    sku: {
      name: kvSkuName 
      family: 'A'
    }
    softDeleteRetentionInDays: kvSoftDeleteRetentionDays
    tenantId: subscription().tenantId
  }
}
