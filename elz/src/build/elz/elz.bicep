
param elzSubName string
param elzRegionId string
param elzRegionName string
param elzManagementRg string

targetScope = 'subscription'

resource rgManagement 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: elzManagementRg
  location: elzRegionName
}

module st './modules/st.bicep' = {
  name: 'stDeployment'
  scope: rgManagement
  params: {
    stName: 'st${uniqueString(rgManagement.id)}diag'
    stSku: 'Standard_LRS'
    stKind: 'StorageV2'
  }
}

module rsv './modules/rsv.bicep' = {
  name: 'rsvDeployment'
  scope: rgManagement
  params: {
    rsvName: 'rsv-${elzSubName}-${elzRegionId}-01'
  }
}

module log './modules/log.bicep' = {
  name: 'logDeployment'
  scope: rgManagement
  params: {
    logName: 'log-${elzSubName}-${elzRegionId}-01'
    aaId: aa.outputs.aaId
  }
}

module kv './modules/kv.bicep' = {
  name: 'kvDeployment'
  scope: rgManagement
  params: {
    kvName: 'kv-${elzSubName}-${elzRegionId}-01'
  }
}

module aa './modules/aa.bicep' = {
  name: 'aaDeployment'
  scope: rgManagement
  params: {
    aaName: 'aa-${elzSubName}-${elzRegionId}-01'
  }
}
