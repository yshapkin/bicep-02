# GitHub Workflows 

## Creating a service principal in Azure

To deploy your resources to Azure, you'll need to create a service principal which GitHub can use. So open a terminal or use Cloud Shell in the Azure portal and type the following commands:
```
az login
az ad sp create-for-rbac \
  --name myApp \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/Bicep \
  --sdk-auth
```
Result:
```
{
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    (...)
}
```

## Creating a GitHub secret

In your GitHub repository, navigate to **Settings** > **Secrets** > **Actions**. Create a new secret called `AZURE_CREDENTIALS` and paste the entire **JSON** object you got from the previous step
<br/>
<br/>
Create another secret for the name of the **resource group** with a name such as `AZURE_RG` and one for the subscription

## Creating a GitHub action
1. First, navigate to your repository and select the Actions menu. Then, set up a workflow to create an empty workflow in your repository. You can rename the file to a different name if you prefer

2. Replace the content of the file with the following snippet
```
on: [push]
name: Azure ARM
jobs:
    build-and-deploy:
        runs-on: ubuntu-latest
        steps:
            # Checkout code
            - uses: actions/checkout@main

              # Log into Azure
            - uses: azure/login@v1
              with:
                  creds: ${{ secrets.AZURE_CREDENTIALS }}
              # Deploy Bicep file
            - name: deploy
              uses: azure/arm-deploy@v1
              with:
                  subscriptionId: ${{ secrets.AZURE_SUBSCRIPTION }}
                  resourceGroupName: ${{ secrets.AZURE_RG }}
                  template: ./main.bicep
                  parameters: storagePrefix=stg
                  failOnStdErr: false
```