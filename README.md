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
```