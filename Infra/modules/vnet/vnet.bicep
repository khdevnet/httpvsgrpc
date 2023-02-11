@description('The location in which all resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the app to create.')
param vnetName string = uniqueString(resourceGroup().id)
var vnetAddressPrefix = '10.0.0.0/16'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: '${vnetName}-sn1'
        properties: {
          addressPrefix: '10.0.0.0/24'
          serviceEndpoints: [
            {
                service: 'Microsoft.Web'
                locations: [
                    '*'
                ]
            }
          ]
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      } 
      {
        name: '${vnetName}-sn2'
        properties: {
          addressPrefix: '10.0.1.0/24'
          serviceEndpoints: [
            {
                service: 'Microsoft.Web'
                locations: [
                    '*'
                ]
            }
          ]
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

output subnets array = vnet.properties.subnets
