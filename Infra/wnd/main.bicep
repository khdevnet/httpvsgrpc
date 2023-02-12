// perf-node-api-uniqueString(subscription().subscriptionId)
// perf-main-api-uniqueString(subscription().subscriptionId)
// perf-rg-asdas
// perf-appinsights-uniqueString(subscription().subscriptionId)
targetScope = 'subscription'

param name string
param appServicePlan object
param tags object
param location string = deployment().location

var suffix = 'wnd-novnet-${uniqueString(subscription().subscriptionId)}'

var rgName = '${name}-rg-${suffix}'
var mainPlanName = '${name}-main-plan-${suffix}'
var mainApiName = '${name}-main-api-${suffix}'
var nodePlanName = '${name}-node-plan-${suffix}'
var nodeApiName = '${name}-node-api-${suffix}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
    name: rgName
    location: location
    tags: tags
}

module mainAppPlan './plan.bicep' = {
    scope: rg
    name: mainPlanName
    params: {
        name: mainPlanName
        sku: appServicePlan.sku
        location: location
    }
}

module mainApi './webapp.bicep' = {
    scope: rg
    name: mainApiName
    params: {
        appServicePlanId: mainAppPlan.outputs.aspId
        name: mainApiName
        location:location
    }
    dependsOn: [
        mainAppPlan
    ]
}

module nodeAppPlan './plan.bicep' = {
    scope: rg
    name: nodePlanName
    params: {
        name: nodePlanName
        sku: appServicePlan.sku
        location: location
    }
}

module nodeApi './webapp.bicep' = {
    scope: rg
    name: nodeApiName
    params: {
        appServicePlanId: nodeAppPlan.outputs.aspId
        name: nodeApiName
        location:location
    }
    dependsOn: [
        nodeAppPlan
    ]
}

