# bicep-02

## az comends

### Install Bicep
```
az bicep install && az bicep upgrade`
```

### Sign in to Azure
```
az login
```

```
az account set --subscription "Concierge Subscription"
```

```
az account list \
   --refresh \
   --query "[?contains(name, 'Concierge Subscription')].id" \
   --output table
```

```
az account set --subscription {your subscription ID}
```

### Deploy the template to Azure
```
az deployment group create --template-file main.bicep

az deployment group create \
  --resource-group ToyTruck \
  --template-file main.bicep \
  --parameters main.parameters.production.json
```

### The what-if command with the modified template
```
az deployment group what-if \
  --template-file main.bicep

az deployment group what-if \
  --resource-group ToyTruck \
  --template-file main.bicep \
  --parameters main.parameters.production.json
```

### Deploy by using complete mode and the confirmation option
```
az deployment group create \
  --mode Complete \
  --confirm-with-what-if \
  --template-file main.bicep
```

### Workflow to migrate your resources to Bicep
1. Convert (decompile the JSON template to Bicep)
```
az bicep decompile --file template.json
```
2. Migrate
  - Create a new empty Bicep file;
  - Copy each resource from your decompiled template;
  - Identify and recreate any missing resources;
3. Refactor
  - Review resource API versions.
  - Review the linter suggestions in your new Bicep file.
  - Revise parameters, variables, and symbolic names.
  - Simplify expressions.
  - Review child and extension resources.
  - Modularize.
  - Add comments and descriptions.
  - Follow Bicep best practices.
4. Test
  - Run the ARM template deployment what-if operation
  - Do a test deployment
```
az deployment group what-if
```
5. Deploy
  - Prepare a rollback plan
  - Run the what-if operation against production
  - Deploy manually
  - Run smoke tests

### Follow Bicep best practices
```
/*
  This Bicep file was developed by the web team.
  It deploys the resources we need for our toy company's website.
*/

// Parameters
@description('Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'prod' // Production environment
  'dev' // Development environment
  'test' // Test environment
])
@description('The list of allowed environment names.')
param environment string = 'prod'

@allowed([
  'P1v3'
  'P2v3'
  'P3v3'
])
@description('The list of allowed App Service plan SKUs.')
param appServicePlanSku string = 'P1v3'

@minValue(1)
@maxValue(10)
@description('The number of allowed App Service plan instances.')
param appServicePlanInstanceCount int = 1

// Variables
@description('The name of the App Service plan.')
var appServicePlanName = 'plan-${environment}-001'

// Resource - App Service Plan
@description('The App Service plan resource name.')
resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku // Specifies the SKU of the App Service plan.
    capacity: appServicePlanInstanceCount
  }
  kind: 'app' // Specifies a Windows App Service plan.
}

// Outputs
@description('The resource ID of the App Service plan.')
output appServicePlanId string = appServicePlan.id
```