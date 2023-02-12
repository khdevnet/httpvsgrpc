@description('Name of Application Insights resource.')
param name string

@description('Type of app you are deploying. This field is for legacy reasons and will not impact the type of App Insights resource you deploy.')
param type string

@description('Which Azure Region to deploy the resource to. This must be a valid Azure regionId.')
param regionId string

@description('See documentation on tags: https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources.')
param tagsArray object

@description('Source of Azure Resource Manager deployment')
param requestSource string

resource component 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: regionId
  tags: tagsArray
  kind: 'other'
  properties: {
    Application_Type: type
    Flow_Type: 'Bluefield'
    Request_Source: requestSource
  }
}