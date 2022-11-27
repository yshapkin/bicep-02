# Get started

## Install Bicep
```
az bicep install && az bicep upgrade
```

## Compile the file
```
az bicep build -f ./main.bicep
```

## Deploy the template to Azure
```
groupName='name'
location='location'
az group create \
  --name $groupName 
  --location $location
```

```
az deployment group create \
  --resource-group $groupName \
  --template-file main.bicep \
  --parameters storageName=uniqueName
```

```
az deployment group create --template-file main.bicep
```

```
az deployment group create \
  --resource-group ToyTruck \
  --template-file main.bicep \
  --parameters main.parameters.production.json
```

## The what-if command with the modified template
```
az deployment group what-if \
  --template-file main.bicep
```
```
az deployment group what-if \
  --resource-group ToyTruck \
  --template-file main.bicep \
  --parameters main.parameters.production.json
```

## Deploy by using complete mode and the confirmation option
```
az deployment group create \
  --mode Complete \
  --confirm-with-what-if \
  --template-file main.bicep
```
<hr/>

[To home page](../README.md)