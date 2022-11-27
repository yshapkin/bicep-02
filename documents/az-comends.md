# Azure CLI commands


### Sign in to Azure
```
az login
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

```
az account list --query "[].{ID:id,Name:name}[?Name=='<NAME>']"
```

<hr/>

[To home page](../README.md)