param name string
param sku object
param location string


resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: name
  location: location
  properties: {
    reserved: true
  }
  sku: sku
  kind: 'linux'
}

output aspId string = appServicePlan.id
