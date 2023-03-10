// perf-node-api-uniqueString(subscription().subscriptionId)
// perf-main-api-uniqueString(subscription().subscriptionId)
// perf-rg-asdas
// perf-appinsights-uniqueString(subscription().subscriptionId)
targetScope = 'subscription'

param name string
param appServicePlan object
param tags object
param location string = deployment().location

var suffix = 'wnd-vnet-${uniqueString(subscription().subscriptionId)}'

var rgName = '${name}-rg-${suffix}'
var vnetName = '${name}-vnet-${suffix}'
var appInsightName = '${name}-appinsight-${suffix}'
var mainPlanName = '${name}-main-plan-${suffix}'
var mainApiName = '${name}-main-api-${suffix}'
var nodePlanName = '${name}-node-plan-${suffix}'
var nodeApiName = '${name}-node-api-${suffix}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
    name: rgName
    location: location
    tags: tags
}

module vnet './vnet.bicep' = {
  scope: rg
  name: vnetName
  params: {
      vnetName:  vnetName
      location: location
  }
}

module appinsights './appinsights.bicep' = {
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

module mainAppPlan './planwnd.bicep' = {
    scope: rg
    name: mainPlanName
    params: {
        name: mainPlanName
        sku: appServicePlan.sku
        location: location
    }
}

module mainApi './webappwnd.bicep' = {
    scope: rg
    name: mainApiName
    params: {
        appServicePlanId: mainAppPlan.outputs.aspId
        name: mainApiName
        location:location
        appInsightName: appinsights.name
        appSettings: [
            {
                name: 'NodeHttpApiBaseUrl'
                value: nodeHttpApi.outputs.baseUrl
            }
        ]
        subnetsId: vnet.outputs.subnets[0].id
    }
    dependsOn: [
        appinsights
        nodeHttpApi
        mainAppPlan
    ]
}

module nodeHttpAppPlan './planwnd.bicep' = {
    scope: rg
    name: nodePlanName
    params: {
        name: nodePlanName
        sku: appServicePlan.sku
        location: location
    }
}

module nodeHttpApi './webappwnd.bicep' = {
    scope: rg
    name: nodeApiName
    params: {
        appServicePlanId: nodeHttpAppPlan.outputs.aspId
        name: nodeApiName
        location:location
        appInsightName: appinsights.name
        subnetsId: vnet.outputs.subnets[1].id
    }
    dependsOn: [
        appinsights
        nodeHttpAppPlan
    ]
}
