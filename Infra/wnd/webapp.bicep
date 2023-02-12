param appServicePlanId string
param location string
param name string
param nodeApiBaseUrl string = ''

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
    name: name
    location: location
    tags: {}
    properties: {
        siteConfig: {
            appSettings: [
                {
                    name: 'NodeApi:BaseUrl'
                    value: nodeApiBaseUrl
                }
            ]
            http20Enabled: true
            windowsFxVersion: 'DOTNETCORE|6.0'
            alwaysOn: true
        }
        serverFarmId: appServicePlanId
        clientAffinityEnabled: false
        httpsOnly: true
    }
}

output baseUrl string = 'https://${webApp.properties.defaultHostName}'
