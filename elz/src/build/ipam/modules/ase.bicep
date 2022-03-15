param aseName string
param aseVnetId string
param location string 

resource ase 'Microsoft.Web/hostingEnvironments@2021-02-01' = {
  name: aseName
  location: location
  kind: 'ASEV2'
  properties: {
    virtualNetwork: {
      id: aseVnetId
    }
  }
}

output aseId string = ase.id
