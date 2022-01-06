
resource lockNetwork 'Microsoft.Authorization/locks@2017-04-01' = {
  name: 'ReadOnlyLock'
  properties: {
    level: 'ReadOnly'
  }
}
