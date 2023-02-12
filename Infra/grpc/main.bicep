// perf-node-api-uniqueString(subscription().subscriptionId)
// perf-main-api-uniqueString(subscription().subscriptionId)
// perf-rg-asdas
// perf-appinsights-uniqueString(subscription().subscriptionId)
targetScope = 'subscription'

param name string
param appServicePlan object
param tags object
param location string = deployment().location

var suffix = 'lnx-grpc2-${uniqueString(subscription().subscriptionId)}'

var rgName = '${name}-rg-${suffix}'
var nodePlanName = '${name}-node-plan-${suffix}'
var nodeApiName = '${name}-node-api-${suffix}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
    name: rgName
    location: location
    tags: tags
}

module nodeAppPlan 'planlnx.bicep' = {
    scope: rg
    name: nodePlanName
    params: {
        name: nodePlanName
        sku: appServicePlan.sku
        location: location
    }
}

module nodeApi 'webapplnx.bicep' = {
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

