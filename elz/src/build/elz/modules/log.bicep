param logName string
param aaId string

resource log 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logName
  location: resourceGroup().location
  properties: {
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource logAuto 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: '${log.name}/Automation'
  properties: {
    resourceId: aaId
  }
}

resource solChange 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'ChangeTracking(${log.name})'
  location: resourceGroup().location
  properties: {
    workspaceResourceId: log.id
  }
  plan: {
    name: 'ChangeTracking(${log.name})'
    publisher: 'Microsoft'
    product: 'OMSGallery/ChangeTracking'
    promotionCode: ''
  }
}

resource solSecurity 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'Security(${log.name})'
  location: resourceGroup().location
  properties: {
    workspaceResourceId: log.id
  }
  plan: {
    name: 'Security(${log.name})'
    publisher: 'Microsoft'
    product: 'OMSGallery/Security'
    promotionCode: ''
  }
}

resource solUpdates 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'Updates(${log.name})'
  location: resourceGroup().location
  properties: {
    workspaceResourceId: log.id
  }
  plan: {
    name: 'Updates(${log.name})'
    publisher: 'Microsoft'
    product: 'OMSGallery/Updates'
    promotionCode: ''
  }
}

resource solVmInsights 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'VMInsights(${log.name})'
  location: resourceGroup().location
  properties: {
    workspaceResourceId: log.id
  }
  plan: {
    name: 'VMInsights(${log.name})'
    publisher: 'Microsoft'
    product: 'OMSGallery/VMInsights'
    promotionCode: ''
  }
}

output logId string = log.id
