param appServicePlanId string
param location string
param name string
param appInsightName string
param appSettings array = []
param subnetsId string

var internalAppSettings = [
    {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: reference('microsoft.insights/components/${appInsightName}', '2015-05-01').InstrumentationKey
    }
    {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: reference('microsoft.insights/components/${appInsightName}', '2015-05-01').ConnectionString
    }
    {
        name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
        value: '~2'
    }
    {
        name: 'XDT_MicrosoftApplicationInsights_Mode'
        value: 'default'
    }
]

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
    name: name
    location: location
    tags: {}
    properties: {
        siteConfig: {
            appSettings: concat(internalAppSettings, appSettings)
            vnetRouteAllEnabled: true
            http20Enabled: true
            linuxFxVersion: 'DOTNETCORE|7.0'
            alwaysOn: true
        }
        virtualNetworkSubnetId: subnetsId
        serverFarmId: appServicePlanId
        clientAffinityEnabled: false
        httpsOnly: true
    }
}

output baseUrl string = 'https://${webApp.properties.defaultHostName}'
