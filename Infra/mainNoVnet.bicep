// perf-node-api-uniqueString(subscription().subscriptionId)
// perf-main-api-uniqueString(subscription().subscriptionId)
// perf-rg-asdas
// perf-appinsights-uniqueString(subscription().subscriptionId)
targetScope = 'subscription'

param name string
param appServicePlan object
param tags object
param location string = deployment().location

var rgName = '${name}-rg-${uniqueString(subscription().subscriptionId)}'
var vnetName = '${name}-vnet-${uniqueString(subscription().subscriptionId)}'

var appInsightName = '${name}-appinsight-${uniqueString(subscription().subscriptionId)}'
var mainPlanName = '${name}-main-plan-${uniqueString(subscription().subscriptionId)}'
var mainApiName = '${name}-main-api-${uniqueString(subscription().subscriptionId)}'
var nodePlanName = '${name}-node-plan-${uniqueString(subscription().subscriptionId)}'
var nodeApiName = '${name}-node-api-${uniqueString(subscription().subscriptionId)}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
    name: rgName
    location: location
    tags: tags
}

module appinsights 'modules/insights/appinsights.bicep' = {
    scope: rg
    name: appInsightName
    params: {
        name: appInsightName
        type: 'web'
        regionId: location
        tagsArray: tags
        requestSource: 'CustomDeployment'
    }
}

module mainAppPlan 'modules/appService/appServicePlan.bicep' = {
    scope: rg
    name: mainPlanName
    params: {
        name: mainPlanName
        sku: appServicePlan.sku
        location: location
    }
}

module mainApi 'modules/webApp/webApp.bicep' = {
    scope: rg
    name: mainApiName
    params: {
        appServicePlanId: mainAppPlan.outputs.aspId
        name: mainApiName
        location:location
        appInsightName: appinsights.name
        nodeApiBaseUrl: nodeApi.outputs.baseUrl
    }
    dependsOn: [
        appinsights
        nodeApi
        mainAppPlan
    ]
}

module nodeAppPlan 'modules/appService/appServicePlan.bicep' = {
    scope: rg
    name: nodePlanName
    params: {
        name: nodePlanName
        sku: appServicePlan.sku
        location: location
    }
}

module nodeApi 'modules/webApp/webApp.bicep' = {
    scope: rg
    name: nodeApiName
    params: {
        appServicePlanId: nodeAppPlan.outputs.aspId
        name: nodeApiName
        location:location
        appInsightName: appinsights.name
    }
    dependsOn: [
        appinsights
        nodeAppPlan
    ]
}

