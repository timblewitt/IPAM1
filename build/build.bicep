param lzName string
param regionName string
param regionId string

var rgIpamName = 'rg-${lzName}-${regionId}-ipam'

targetScope = 'subscription'
resource rgIpam 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgIpamName
  location: regionName
}

module sa './modules/sa.bicep' = {
  name: 'saDeployment'
  scope: rgIpam
  params: {
    saName: 'sa${uniqueString('resourceGroup.id')}ipam'
    saSku: 'Standard_LRS'
    saKind: 'StorageV2'
  }
}

module asp './modules/asp.bicep' = {
  name: 'aspDeployment'
  scope: rgIpam
  params: {
    aspName: 'asp-${lzName}-${regionId}-ipam'
    aspSku: 'EP1'
    aspTier: 'Premium'
  }
}

module law './modules/law.bicep' = {
  name: 'lawDeployment'
  scope: rgIpam
  params: {
    lawName: 'law-${lzName}-${regionId}-ipam'
  }
}

module fa './modules/fa.bicep' = {
  name: 'faDeployment'
  scope: rgIpam
  params: {
    faName: 'fa-${lzName}-${regionId}-ipam'
    faAspId: asp.outputs.aspId
    faSaName: sa.outputs.saName
    faSaId: sa.outputs.saId
    faSaApiVersion: sa.outputs.saApiVersion
    lawId: law.outputs.lawId
  }
}
