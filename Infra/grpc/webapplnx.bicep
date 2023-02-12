param appServicePlanId string
param location string
param name string

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
    name: name
    location: location
    tags: {}
    properties: {
        siteConfig: {
            http20Enabled: true
            linuxFxVersion: 'DOTNETCORE|7.0'
            alwaysOn: true
        }
        serverFarmId: appServicePlanId
        clientAffinityEnabled: false
        httpsOnly: true
    }
}

output baseUrl string = 'https://${webApp.properties.defaultHostName}'
